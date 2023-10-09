import { IResolvers } from "@graphql-tools/utils/typings/Interfaces";
import { gql } from "apollo-server-express";
import { hasuraSubscriptionClient } from "../../services/hasura";
import { saveHasuraSubscription } from "../../services/hasuraSubscriptions";
import { pubsub } from "../../services/pubsub";

/** TYPES */

type ActualData = {
  data: {
    wpt_exercises: {
      exercise_id: string;
      name: string;
      note: string;
      wpt_completed_sets_aggregate: {
        aggregate: {
          max: {
            personal_record: number;
          }
        }
      };
      workouts: {
        wpt_workout: {
          name: string;
          day_of_week: number;
        }
        wpt_set_references: {
          wpt_set_details: {
            working_weight: number;
          }[];
        }[];
      }[];
    }[];
  };
};

type DesiredData = {
  exercises: {
    exercise_id: string;
    name: string;
    note: string;
    personal_record: number;
    workouts: {
      name: string;
      day_of_week: number;
      working_weight: number;
    }[];
  }[];
};

/** GRAPHQL */

const EXERCISES_SUBSCRIPTION = gql`
    subscription get_exercise_list {
        wpt_exercises(order_by: {wpt_workout_exercises_aggregate: {avg: {order_number: asc}}}) {
            exercise_id
            name
            note
            wpt_completed_sets_aggregate {
                aggregate {
                    max {
                        personal_record: weight
                    }
                }
            }
            workouts: wpt_workout_exercises {
                wpt_workout {
                    name
                    day_of_week
                }
                wpt_set_references(limit: 1, order_by: {wpt_set_details_aggregate: {max: {weight: desc}}}) {
                    wpt_set_details(order_by: {created_at: desc}, limit: 1) {
                        working_weight: weight
                    }
                }
            }
        }
    }
`;

export const scr2ExerciseListTypeDefs = gql`
    extend type subscription_root {
        scr2_exercise_list: [scr2_exercise]
    }

    type scr2_exercise {
        exercise_id: String!
        name: String!
        note: String
        personal_record: Float
        workouts: [scr2_workout]
    }

    type scr2_workout {
        name: String!
        day_of_week: Int
        working_weight: Float
    }
`;

/** TRANSFORMER */

function transformExerciseData(input: ActualData): DesiredData {
  return {
    exercises: input.data.wpt_exercises.map(exercise => ({
      exercise_id: exercise.exercise_id,
      name: exercise.name,
      note: exercise.note,
      personal_record: exercise.wpt_completed_sets_aggregate.aggregate.max.personal_record,
      workouts: exercise.workouts.map(workout => ({
        name: workout.wpt_workout.name,
        day_of_week: workout.wpt_workout.day_of_week,
        working_weight: workout.wpt_set_references[0]?.wpt_set_details[0]?.working_weight || 0,
      })),
    })),
  };
}

/** RESOLVERS */

export const scr2ExerciseListResolvers: IResolvers = {
  subscription_root: {
    scr2_exercise_list: {
      subscribe: (_, __, { subscriptionKey, token }) => {
        const subscription = startExerciseSubscription(subscriptionKey, token);
        saveHasuraSubscription(subscriptionKey, subscription)
        return pubsub.asyncIterator([subscriptionKey]);
      },
    },
  },
};

function startExerciseSubscription(subscriptionKey: string, bearerToken: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: EXERCISES_SUBSCRIPTION.loc?.source.body! },
    {
      next: (data) => {
        const transformed = transformExerciseData(data as ActualData);
        pubsub.publish(subscriptionKey, { scr2_exercise_list: transformed.exercises }).catch(console.error);
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.info("Subscription completed"),
    },
  );
}
