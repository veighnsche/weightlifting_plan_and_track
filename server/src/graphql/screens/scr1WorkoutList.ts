import { IResolvers } from "@graphql-tools/utils/typings/Interfaces";
import { gql } from "apollo-server-express";
import { hasuraSubscriptionClient } from "../../services/hasura";
import { saveHasuraSubscription } from "../../services/hasuraSubscriptions";
import { pubsub } from "../../services/pubsub";
import { sortByDayOfWeek } from "../../utils/date";

/** TYPES */

type ActualData = {
  data: {
    wpt_workouts: {
      workout_id: string;
      name: string;
      day_of_week: number;
      note: string;
      wpt_workout_exercises: {
        wpt_exercise: {
          name: string;
        }
      }[];
      wpt_workout_exercises_aggregate: {
        aggregate: {
          total_exercises: number;
        }
      };
      total_sets_aggragate: {
        wpt_set_references_aggregate: {
          aggregate: {
            total_sets: number;
          }
        }
      }[];
    }[];
  };
};

type DesiredData = {
  workouts: {
    workout_id: string;
    name: string;
    day_of_week: number;
    day_of_week_name: string;
    note: string;
    exercises: string[];
    total_exercises: number;
    total_sets: number;
  }[];
};

/** GRAPHQL */

const WORKOUTS_SUBSCRIPTION = gql`
    subscription GetWorkouts {
        wpt_workouts {
            workout_id
            name
            day_of_week
            note
            wpt_workout_exercises(limit: 3, order_by: {order_number: asc}) {
                wpt_exercise {
                    name
                }
            }
            wpt_workout_exercises_aggregate {
                aggregate {
                    total_exercises: count
                }
            }
            total_sets_aggragate: wpt_workout_exercises {
                wpt_set_references_aggregate {
                    aggregate {
                        total_sets: count
                    }
                }
            }
        }
    }
`;

export const scr1WorkoutListTypeDefs = gql`
    extend type subscription_root {
        scr1_workout_list: [scr1_workout]
    }

    type scr1_workout {
        workout_id: String!
        name: String!
        day_of_week: Int
        day_of_week_name: String
        note: String
        exercises: [String]
        total_exercises: Int!
        total_sets: Int!
    }
`;

/** TRANSFORMER */

function transformData(input: ActualData): DesiredData {
  const daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  return {
    workouts: input.data.wpt_workouts.map(workout => ({
      workout_id: workout.workout_id,
      name: workout.name,
      day_of_week: workout.day_of_week,
      day_of_week_name: daysOfWeek[workout.day_of_week],
      note: workout.note,
      exercises: workout.wpt_workout_exercises.map(exercise => exercise.wpt_exercise.name),
      total_exercises: workout.wpt_workout_exercises_aggregate.aggregate.total_exercises,
      total_sets: workout.total_sets_aggragate.reduce((sum, aggr) => sum + aggr.wpt_set_references_aggregate.aggregate.total_sets, 0),
    })).sort(sortByDayOfWeek),
  };
}

/** RESOLVERS */

export const scr1WorkoutListResolvers: IResolvers = {
  subscription_root: {
    scr1_workout_list: {
      subscribe: (_, __, { subscriptionKey, token }) => {
        const subscription = startWorkoutsSubscription(subscriptionKey, token);
        saveHasuraSubscription(subscriptionKey, subscription);
        return pubsub.asyncIterator([subscriptionKey]);
      },
    },
  },
};

function startWorkoutsSubscription(subscriptionKey: string, bearerToken: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: WORKOUTS_SUBSCRIPTION.loc?.source.body! },
    {
      next: (data) => {
        const transformed = transformData(data as ActualData);
        pubsub.publish(subscriptionKey, { scr1_workout_list: transformed.workouts }).catch(console.error);
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.info("Subscription completed"),
    },
  );
}