// src/graphql-client.ts
import { ApolloClient, HttpLink, InMemoryCache } from "@apollo/client";
import { WebSocketLink } from "@apollo/client/link/ws";

const HASURA_ENDPOINT = "ws://your-hasura-instance:8080/v1/graphql";

export const hasuraAdminClient = new ApolloClient({
  link: new HttpLink({
    uri: HASURA_ENDPOINT,
    headers: {
      "x-hasura-admin-secret": process.env.HASURA_GRAPHQL_ADMIN_SECRET!,
    },
  }),
  cache: new InMemoryCache(),
});

const hasuraWsClient = new ApolloClient({
  link: new WebSocketLink({
    uri: HASURA_ENDPOINT,
    options: {
      reconnect: true,
    },
  }),
  cache: new InMemoryCache(),
});