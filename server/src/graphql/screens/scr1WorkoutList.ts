import { gql } from "apollo-server-express";
import { hasuraSubscriptionClient } from "../../services/hasura";
import { pubsub } from "../../services/pubsub";

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
                    totalExercises: count
                }
            }
            totalSetsAggragate: wpt_workout_exercises {
                wpt_set_references_aggregate {
                    aggregate {
                        totalSets: count
                    }
                }
            }
        }
    }
`;

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
          totalExercises: number;
        }
      };
      totalSetsAggragate: {
        wpt_set_references_aggregate: {
          aggregate: {
            totalSets: number;
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
    note: string;
    exercises: string[];
    totalExercises: number;
    totalSets: number;
  }[];
};

export const Scr1WorkoutListTypeDefs = gql`
    type scr1_workout {
        workout_id: String!
        name: String!
        day_of_week: Int
        note: String
        exercises: [String]
        totalExercises: Int!
        totalSets: Int!
    }
`;

function transformData(input: ActualData): DesiredData {
  const daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  return {
    workouts: input.data.wpt_workouts.map(workout => ({
      workout_id: workout.workout_id,
      name: workout.name,
      day_of_week: workout.day_of_week,
      note: workout.note,
      exercises: workout.wpt_workout_exercises.map(exercise => exercise.wpt_exercise.name),
      totalExercises: workout.wpt_workout_exercises_aggregate.aggregate.totalExercises,
      totalSets: workout.totalSetsAggragate.reduce((sum, aggr) => sum + aggr.wpt_set_references_aggregate.aggregate.totalSets, 0),
    })),
  };
}

export function startWorkoutsSubscription(bearerToken: string, subscriptionKey: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: WORKOUTS_SUBSCRIPTION.loc?.source.body! },
    {
      next: (data) => {
        const transformed = transformData(data as ActualData);

        pubsub.publish(subscriptionKey, { scr1WorkoutList: transformed.workouts });
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.info("Subscription completed"),
    },
  );
}