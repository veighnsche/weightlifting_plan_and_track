import { mergeTypeDefs } from "@graphql-tools/merge";
import { makeExecutableSchema } from "@graphql-tools/schema";
import { IExecutableSchemaDefinition } from "@graphql-tools/schema/typings/types";
import { gql } from "apollo-server-express";
import { fetchHasuraSchema } from "./hasura";
import { pubsub } from "./pubsub";
import { Scr1WorkoutListTypeDefs, startWorkoutsSubscription } from "../graphql/screens/scr1WorkoutList";

export async function getSchema() {
  const hasuraSchema = await fetchHasuraSchema();
  return makeExecutableSchema({
    typeDefs: mergeTypeDefs([hasuraSchema, typeDefs, Scr1WorkoutListTypeDefs]),
    resolvers,
  });
}

const typeDefs: IExecutableSchemaDefinition["typeDefs"] = gql`
    schema {
        query: Query
        mutation: Mutation
        subscription: Subscription
    }

    type Query {
        search: String
    }
    
    type Mutation {
        search: String
    }

    type Subscription {
        scr1WorkoutList: [scr1_workout!]!
    }
`;

let subscriptions: Record<string, () => void> = {};

const resolvers: IExecutableSchemaDefinition["resolvers"] = {
  Query: {
    search: () => "Hello World!",
  },
  Mutation: {
    search: () => "Hello World!",
  },
  Subscription: {
    scr1WorkoutList: {
      subscribe: (_, __, { token, subscriptionKey }) => {
        subscriptions[subscriptionKey] = startWorkoutsSubscription(token, subscriptionKey);
        // count active subscriptions
        console.log("STARTED: Active subscriptions:", Object.keys(subscriptions).length);
        return pubsub.asyncIterator([subscriptionKey]);
      },

    },
  },
};

export function stopSubscription(subscriptionKey: string) {
  if (subscriptions[subscriptionKey]) {
    subscriptions[subscriptionKey]();
    delete subscriptions[subscriptionKey];
    console.log("STOPPED: Active subscriptions:", Object.keys(subscriptions).length);
  }
}