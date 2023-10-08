import { makeExecutableSchema } from "@graphql-tools/schema";
import { IExecutableSchemaDefinition } from "@graphql-tools/schema/typings/types";
import { gql } from "apollo-server-express";
import { PubSub } from "graphql-subscriptions";
import { hasuraSubscriptionClient } from "../services/hasura";

const pubsub = new PubSub();
const SOMETHING_CHANGED_TOPIC = "somethingChanged";
const WORKOUTS_CHANGED_TOPIC = "workoutsChanged";

const typeDefs: IExecutableSchemaDefinition["typeDefs"] = gql`
    type Workout {
        workout_id: String!
        name: String!
    }

    type Query {
        search: String
    }

    type Subscription {
        somethingChanged: String
        getWorkouts: [Workout!]!
    }
`;


const resolvers: IExecutableSchemaDefinition["resolvers"] = {
  Query: {
    search: () => "Hello World!",
  },
  Subscription: {
    somethingChanged: {
      subscribe: () => pubsub.asyncIterator([SOMETHING_CHANGED_TOPIC]),
    },
    getWorkouts: {
      subscribe: (_, __, { token }) => {
        startWorkoutsSubscription(token);
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
    subscription MySubscription {
        wpt_workouts {
            workout_id
            name
        }
    }
`;

function startWorkoutsSubscription(bearerToken: string) {
  return hasuraSubscriptionClient(bearerToken).subscribe(
    { query: WORKOUTS_SUBSCRIPTION.loc?.source.body! },
    {
      next: (data) => {

        // transform the data here

        pubsub.publish(WORKOUTS_CHANGED_TOPIC, { getWorkouts: data!.data!.wpt_workouts });
      },
      error: (error) => console.error("Subscription error:", error),
      complete: () => console.log("Subscription completed"),
    },
  );
}