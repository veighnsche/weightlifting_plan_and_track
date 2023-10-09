// setupApolloServer.ts

import { ApolloServer } from "apollo-server-express";
import { schema } from "../graphql";
import { HasuraRESTDataSource } from "./hasura";

export function setupApolloServer(): ApolloServer {
  // Apollo Server setup
  return new ApolloServer({
    schema,
    context: ({ req }) => {
      const token = req.headers.authorization || "";
      return { token };
    },
    dataSources: () => ({
      hasura: new HasuraRESTDataSource(),
    }),
  });
}