import { mergeResolvers, mergeTypeDefs } from "@graphql-tools/merge";
import { makeExecutableSchema } from "@graphql-tools/schema";
import { TypeSource } from "@graphql-tools/utils";
import { IResolvers } from "@graphql-tools/utils/typings/Interfaces";
import { gql } from "apollo-server-express";
import { scr1WorkoutListResolvers, scr1WorkoutListTypeDefs } from "../graphql/screens/scr1WorkoutList";
import { fetchHasuraSchema } from "./hasura";

export async function getSchema() {
  const hasuraSchema = await fetchHasuraSchema();
  return makeExecutableSchema({
    typeDefs: mergeTypeDefs([hasuraSchema, typeDefs, scr1WorkoutListTypeDefs]),
    resolvers: mergeResolvers([resolvers, scr1WorkoutListResolvers]),
  });
}

const typeDefs: TypeSource = gql`
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

const resolvers: IResolvers = {
  Query: {
    search: () => "Hello World!",
  },
  Mutation: {
    search: () => "Hello World!",
  },
};