// setupApolloServer.ts

import { ApolloServer } from "apollo-server-express";
import { getSchema } from "./graphql";
import { HasuraRESTDataSource } from "./hasura";

export async function setupApolloServer(): Promise<ApolloServer> {
  const schema = await getSchema();

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