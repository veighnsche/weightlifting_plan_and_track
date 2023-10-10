import { IResolvers } from "@graphql-tools/utils/typings/Interfaces";
import { gql } from "apollo-server-express";
import Decimal from "decimal.js";
import { hasuraSubscriptionClient } from "../../services/hasura";
import { saveHasuraSubscription } from "../../services/hasuraSubscriptions";
import { pubsub } from "../../services/pubsub";

/** TYPES */

type ActualData = {
  data: {
    wpt_workouts_by_pk: {
      workout_id: string;
      name: string;
      day_of_week?: number;
      note?: string;
      wpt_workout_exercises: {
        wpt_exercise: {
          exercise_id: string;
          name: string;
          note?: string;
        };
        wpt_set_references: {
          order_number: number;
          note?: string;
          wpt_set_details: {
            rep_count: number;
            weight?: number;
            weight_text?: string;
            weight_adjustment?: Record<number, number>;
            rest_time_before?: number;
            note?: string;
          }[];
        }[];
      }[];
      wpt_completed_workouts: {
        completed_workout_id: string;
        started_at: string;
        note?: string;
        is_active: boolean;
        wpt_completed_sets_aggregate: {
          aggregate: {
            completed_reps_amount: number;
          };
        };
      }[];
    };
  };
};

type DesiredData = {
  workout_id: string;
  name: string;
  day_of_week?: number;
  note?: string;
  total_exercises: number;
  total_sets: number;
  total_volume: number;
  total_time: number;
  exercises: {
    exercise_id: string;
    name: string;
    note?: string;
    sets_count: number;
    max_reps: number;
    total_reps: number;
    min_weight?: number;
    max_weight?: number;
    max_rest?: number;
    total_time: number;
    total_volume?: number;
    sets: {
      set_number: number;
      reps: number;
      weight?: number;
      weight_text?: string;
      weight_adjustments?: Record<number, number>;
      rest_time_before?: number;
      note?: string;
    }[];
  }[];
  completed_workouts: {
    completed_workout_id: string;
    started_at: string;
    note?: string;
    is_active: boolean;
    completed_reps_amount: number;
  }[];
};

/** GRAPHQL */

const SUBSCRIPTION = gql`
    subscription get_workout_details($workout_id: uuid!) {
        wpt_workouts_by_pk(workout_id: $workout_id) {
            workout_id
            name
            day_of_week
            note
            wpt_workout_exercises(order_by: {order_number: asc}) {
                wpt_exercise {
                    exercise_id
                    name
                    note
                }
                wpt_set_references(order_by: {order_number: asc}) {
                    order_number
                    note
                    wpt_set_details(order_by: {created_at: desc}, limit: 1) {
                        rep_count
                        weight
                        weight_text
                        weight_adjustment
                        rest_time_before
                        note
                    }
                }
            }
            wpt_completed_workouts(order_by: {started_at: desc}) {
                completed_workout_id
                started_at
                note
                is_active
                wpt_completed_sets_aggregate {
                    aggregate {
                        completed_reps_amount: count
                    }
                }
            }
        }
    }
`;

export const scr3WorkoutDetailsTypeDefs = gql`
    extend type subscription_root {
        scr3_workout_details(workout_id: String!): scr3_workout!
    }

    type scr3_workout {
        workout_id: String!
        name: String!
        day_of_week: Int
        note: String
        total_exercises: Int!
        total_sets: Int!
        total_volume: Float!
        total_time: Int!
        exercises: [scr3_exercise]
        completed_workouts: [scr3_completed_workout]
    }

    type scr3_exercise {
        exercise_id: String!
        name: String!
        note: String
        sets_count: Int!
        max_reps: Int!
        total_reps: Int!
        min_weight: Float
        max_weight: Float
        max_rest: Int
        total_time: Int!
        total_volume: Float
        sets: [scr3_set]
    }

    type scr3_completed_workout {
        completed_workout_id: String!
        started_at: String!
        note: String
        is_active: Boolean!
        completed_reps_amount: Int!
    }

    type scr3_set {
        set_number: Int!
        reps: Int!
        weight: Float
        weight_text: String
        weight_adjustments: jsonb
        rest_time_before: Int
        note: String
    }
`;


/** TRANSFORMER */

function transformData(input: ActualData): DesiredData {
  const workout = input.data.wpt_workouts_by_pk;

  let total_sets = 0;
  let total_volume = new Decimal(0);
  let total_time = new Decimal(0);

  const exercises = workout.wpt_workout_exercises.map(exercise => {
    const sets_count = exercise.wpt_set_references.length;
    total_sets += sets_count;

    let max_reps = 0;
    let total_reps = 0;
    let min_weight = new Decimal(Infinity);
    let max_weight = new Decimal(0);
    let max_rest = new Decimal(0);
    let exercise_total_time = new Decimal(0);
    let exercise_total_volume = new Decimal(0);

    const sets = exercise.wpt_set_references.map(set_ref => {
      const reps = set_ref.wpt_set_details[0]?.rep_count || 0;
      const weight = new Decimal(set_ref.wpt_set_details[0]?.weight || 0);
      const rest_time_before = new Decimal(set_ref.wpt_set_details[0]?.rest_time_before || 0);

      max_reps = Math.max(max_reps, reps);
      total_reps += reps;
      min_weight = Decimal.min(min_weight, weight);
      max_weight = Decimal.max(max_weight, weight);
      max_rest = Decimal.max(max_rest, rest_time_before);
      exercise_total_time = exercise_total_time.plus(rest_time_before);
      exercise_total_volume = exercise_total_volume.plus(weight.times(reps));

      return {
        set_number: set_ref.order_number,
        reps,
        weight: weight.toNumber(),
        weight_text: set_ref.wpt_set_details[0]?.weight_text,
        weight_adjustments: set_ref.wpt_set_details[0]?.weight_adjustment,
        rest_time_before: rest_time_before.toNumber(),
        note: set_ref.note,
      };
    });

    total_volume = total_volume.plus(exercise_total_volume);
    total_time = total_time.plus(exercise_total_time);

    return {
      exercise_id: exercise.wpt_exercise.exercise_id,
      name: exercise.wpt_exercise.name,
      note: exercise.wpt_exercise.note,
      sets_count,
      max_reps,
      total_reps,
      min_weight: min_weight.toNumber(),
      max_weight: max_weight.toNumber(),
      max_rest: max_rest.toNumber(),
      total_time: exercise_total_time.toNumber(),
      total_volume: exercise_total_volume.toNumber(),
      sets,
    };
  });

  const completed_workouts = workout.wpt_completed_workouts.map(completed_workout => ({
    completed_workout_id: completed_workout.completed_workout_id,
    started_at: completed_workout.started_at,
    note: completed_workout.note,
    is_active: completed_workout.is_active,
    completed_reps_amount: completed_workout.wpt_completed_sets_aggregate.aggregate.completed_reps_amount,
  }));

  return {
    workout_id: workout.workout_id,
    name: workout.name,
    day_of_week: workout.day_of_week,
    note: workout.note,
    total_exercises: exercises.length,
    total_sets,
    total_volume: total_volume.toNumber(),
    total_time: total_time.toNumber(),
    exercises,
    completed_workouts,
  };
}


/** RESOLVERS */

export const scr3WorkoutDetailsResolvers: IResolvers = {
  subscription_root: {
    scr3_workout_details: {
      subscribe: (_, { workout_id }, { subscriptionKey, token }) => {
        const subscription = startSubscription(subscriptionKey, token, workout_id);
        saveHasuraSubscription(subscriptionKey, subscription);
        return pubsub.asyncIterator([subscriptionKey]);
      },
    },
  },
};

function startSubscription(subscriptionKey: string, bearerToken: string, workout_id: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: SUBSCRIPTION.loc?.source.body!, variables: { workout_id } },
    {
      next: (data) => {
        const transformed = transformData(data as ActualData);
        pubsub.publish(subscriptionKey, { scr3_workout_details: transformed }).catch(console.error);
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.info("Subscription completed"),
    },
  );
}
