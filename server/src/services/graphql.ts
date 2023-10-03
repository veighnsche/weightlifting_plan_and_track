// src/graphql-client.ts
import { ApolloClient, HttpLink, InMemoryCache } from "@apollo/client";

const client = new ApolloClient({
  link: new HttpLink({
    uri: "http://your-hasura-instance:8080/v1/graphql",
    headers: {
      "x-hasura-admin-secret": process.env.HASURA_GRAPHQL_ADMIN_SECRET!,
    },
  }),
  cache: new InMemoryCache(),
});

export default client;
