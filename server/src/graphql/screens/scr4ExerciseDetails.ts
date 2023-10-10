import { IResolvers } from "@graphql-tools/utils/typings/Interfaces";
import { gql } from "apollo-server-express";
import Decimal from "decimal.js";
import { hasuraSubscriptionClient } from "../../services/hasura";
import { saveHasuraSubscription } from "../../services/hasuraSubscriptions";
import { pubsub } from "../../services/pubsub";

/** TYPES */

type ActualData = {
  data: {
    wpt_exercises_by_pk: {
      exercise_id: string;
      name: string;
      note?: string;
      wpt_workout_exercises: {
        note?: string;
        wpt_workout: {
          workout_id: string;
          name: string;
          note?: string;
          day_of_week?: number;
        };
      }[];
      wpt_completed_sets: {
        completed_at: string;
        rep_count: number;
        weight?: number;
        weight_text?: string;
        weight_adjustment?: Record<number, number>;
        rest_time_before?: number;
        note?: string;
        wpt_set_detail: {
          rep_count: number;
          note?: string;
          weight?: number;
          weight_adjustment?: Record<number, number>;
          weight_text?: string | null;
          rest_time_before?: number;
          wpt_set_reference: {
            note?: string;
          };
        };
        wpt_completed_workout: {
          completed_workout_id: string;
          started_at: string;
          wpt_workout: {
            name: string;
          };
        };
      }[];
    };
  }
};


type DesiredData = {
  exercise_id: string;
  name: string;
  totalCompletedWorkouts: number;
  totalCompletedVolume: number;
  avgDiffInTotalVolume: number;
  note?: string;
  workouts: {
    workoutId: string;
    name: string;
    note?: string;
    dayOfWeek?: number;
  }[];
  completedWorkouts: {
    name: string;
    completedWorkoutId: string;
    startedAt: string;
    note?: string;
    completedSets: number;
    maxReps: number;
    minWeight: number;
    maxWeight: number;
    avgRestTimeBefore: number;
    completedRepsAmount: number;
    totalVolume: number;
    plannedTotalVolume: number;
    differenceInTotalVolume: number;
  }[];
};

/** GRAPHQL */

const SUBSCRIPTION = gql`
    subscription get_exercise_detail($exercise_id: uuid!) {
        wpt_exercises_by_pk(exercise_id: $exercise_id) {
            exercise_id
            name
            note
            wpt_workout_exercises {
                note
                wpt_workout {
                    name
                    note
                    day_of_week
                    workout_id
                }
            }
            wpt_completed_sets(order_by: {completed_at: desc}) {
                completed_at
                rep_count
                weight
                weight_text
                weight_adjustment
                rest_time_before
                note
                wpt_set_detail {
                    rep_count
                    note
                    weight
                    weight_adjustment
                    weight_text
                    rest_time_before
                    wpt_set_reference {
                        note
                    }
                }
                wpt_completed_workout {
                    completed_workout_id
                    started_at
                    wpt_workout {
                        name
                    }
                }
            }
        }
    }
`;

export const scr4ExerciseDetailsTypeDefs = gql`
    extend type subscription_root {
        scr4_exercise_details(exercise_id: String!): scr4_exercise!
    }

    type scr4_exercise {
        name: String!
        totalCompletedWorkouts: Int!
        totalCompletedVolume: Float!
        avgDiffInTotalVolume: Float!
        note: String
        workouts: [scr4_workout!]!
        completedWorkouts: [scr4_completed_workout!]!
    }

    type scr4_workout {
        workoutId: String!
        name: String!
        note: String
        dayOfWeek: Int
    }

    type scr4_completed_workout {
        name: String!
        completedWorkoutId: String!
        startedAt: String!
        note: String
        completedSets: Int!
        maxReps: Int!
        minWeight: Float!
        maxWeight: Float!
        avgRestTimeBefore: Float!
        completedRepsAmount: Int!
        totalVolume: Float!
        plannedTotalVolume: Float!
        differenceInTotalVolume: Float!
    }
`;

/** TRANSFORMER */

function transformData(data: ActualData): DesiredData {
  const { wpt_exercises_by_pk } = data.data;
  const { wpt_workout_exercises, wpt_completed_sets, name, note, exercise_id } = wpt_exercises_by_pk;

  // Extracting workouts
  const workouts = wpt_workout_exercises.map(({ wpt_workout }) => ({
    workoutId: wpt_workout.workout_id,
    name: wpt_workout.name,
    note: wpt_workout.note,
    dayOfWeek: wpt_workout.day_of_week,
  }));

  // Extracting and computing completedWorkouts fields
  const completedWorkoutsMap: Record<string, any> = {};

  wpt_completed_sets.forEach(set => {
    const { wpt_completed_workout, rep_count, weight, rest_time_before, wpt_set_detail } = set;
    const workoutId = wpt_completed_workout.completed_workout_id;

    if (!completedWorkoutsMap[workoutId]) {
      completedWorkoutsMap[workoutId] = {
        name: wpt_completed_workout.wpt_workout.name,
        completedWorkoutId: workoutId,
        startedAt: wpt_completed_workout.started_at,
        completedSets: new Decimal(0),
        maxReps: new Decimal(0),
        minWeight: new Decimal(Infinity),
        maxWeight: new Decimal(0),
        avgRestTimeBefore: new Decimal(0),
        completedRepsAmount: new Decimal(0),
        totalVolume: new Decimal(0),
        plannedTotalVolume: new Decimal(0),
        differenceInTotalVolume: new Decimal(0),
      };
    }

    const workout = completedWorkoutsMap[workoutId];
    workout.completedSets = workout.completedSets.plus(1);
    workout.maxReps = Decimal.max(workout.maxReps, rep_count);
    if (weight) {
      workout.minWeight = Decimal.min(workout.minWeight, weight);
      workout.maxWeight = Decimal.max(workout.maxWeight, weight);
    }
    workout.avgRestTimeBefore = workout.avgRestTimeBefore.plus(rest_time_before || 0);
    workout.completedRepsAmount = workout.completedRepsAmount.plus(rep_count);
    workout.totalVolume = workout.totalVolume.plus(new Decimal(weight || 0).times(rep_count));
    workout.plannedTotalVolume = workout.plannedTotalVolume.plus(new Decimal(wpt_set_detail.weight || 0).times(wpt_set_detail.rep_count));
  });

  const completedWorkouts = Object.values(completedWorkoutsMap).map(workout => {
    workout.avgRestTimeBefore = workout.avgRestTimeBefore.dividedBy(workout.completedSets);
    workout.differenceInTotalVolume = workout.totalVolume.minus(workout.plannedTotalVolume);

    return {
      ...workout,
      minWeight: workout.minWeight.toNumber(),
      maxWeight: workout.maxWeight.toNumber(),
      avgRestTimeBefore: workout.avgRestTimeBefore.toNumber(),
      completedRepsAmount: workout.completedRepsAmount.toNumber(),
      totalVolume: workout.totalVolume.toNumber(),
      plannedTotalVolume: workout.plannedTotalVolume.toNumber(),
      differenceInTotalVolume: workout.differenceInTotalVolume.toNumber(),
    };
  });

  return {
    exercise_id,
    name,
    totalCompletedWorkouts: completedWorkouts.length,
    totalCompletedVolume: completedWorkouts.reduce((acc, curr) => acc.plus(curr.totalVolume), new Decimal(0)).toNumber(),
    avgDiffInTotalVolume: completedWorkouts.reduce((acc, curr) => acc.plus(curr.differenceInTotalVolume), new Decimal(0)).dividedBy(completedWorkouts.length).toNumber(),
    note,
    workouts,
    completedWorkouts,
  };
}


/** RESOLVERS */

export const scr4ExerciseDetailsResolvers: IResolvers = {
  subscription_root: {
    scr4_exercise_details: {
      subscribe: (_, { exercise_id }, { subscriptionKey, token }) => {
        const subscription = startSubscription(subscriptionKey, token, exercise_id);
        saveHasuraSubscription(subscriptionKey, subscription);
        return pubsub.asyncIterator(subscriptionKey);
      },
    },
  },
};

function startSubscription(subscriptionKey: string, bearerToken: string, exercise_id: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: SUBSCRIPTION.loc?.source.body!, variables: { exercise_id } },
    {
      next: (data) => {
        const transformedData = transformData(data as ActualData);
        console.log("Transformed data:", transformedData);
        pubsub.publish(subscriptionKey, { scr4_exercise_details: transformedData }).catch(console.error);
      },
      error: (error) => console.error("Subscription error:", error),
      complete() {
        console.info("Subscription completed");
      },
    },
  );
}