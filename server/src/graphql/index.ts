import { makeExecutableSchema } from "@graphql-tools/schema";
import { IExecutableSchemaDefinition } from "@graphql-tools/schema/typings/types";
import { gql } from "apollo-server-express";
import { PubSub } from "graphql-subscriptions";
// import { connections } from "../index";
import { hasuraSubscriptionClient } from "../services/hasura";

const pubsub = new PubSub();
const WORKOUTS_CHANGED_TOPIC = "workoutsChanged";


const typeDefs: IExecutableSchemaDefinition["typeDefs"] = gql`
    type scr1_workout {
        workout_id: String!
        name: String!
        day_of_week: Int
        note: String
        exercises: [String]
        totalExercises: Int!
        totalSets: Int!
    }

    type Query {
        search: String
    }

    type Subscription {
        getWorkouts: [scr1_workout!]!
    }
`;


const resolvers: IExecutableSchemaDefinition["resolvers"] = {
  Query: {
    search: () => "Hello World!",
  },
  Subscription: {
    getWorkouts: {
      subscribe: (_, __, { token, uid }) => {
        startWorkoutsSubscription(token);
        // connections[uid].push(startWorkoutsSubscription(token));
        return pubsub.asyncIterator([WORKOUTS_CHANGED_TOPIC]);
      },
    },
  },
};

export const schema = makeExecutableSchema({
  typeDefs,
  resolvers,
});

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

function startWorkoutsSubscription(bearerToken: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: WORKOUTS_SUBSCRIPTION.loc?.source.body! },
    {
      next: (data) => {
        const transformed = transformData(data as ActualData);

        pubsub.publish(WORKOUTS_CHANGED_TOPIC, { getWorkouts: transformed.workouts });
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.info("Subscription completed"),
    },
  );
}