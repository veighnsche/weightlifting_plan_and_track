import { RESTDataSource } from "apollo-datasource-rest";
import { buildClientSchema, getIntrospectionQuery, printSchema } from "graphql";
import { createClient } from "graphql-ws";
import { DocumentNode } from "graphql/language";
import ws from "ws";


export class HasuraRESTDataSource extends RESTDataSource {
  constructor() {
    super();
    this.baseURL = "http://localhost:8080/v1/graphql";
  }

  async queryHasura(BearerToken: string, query: DocumentNode, variables?: Record<string, any>) {
    return this.post("", {
      query: query.loc?.source.body,
      variables: variables,
    }, {
      headers: {
        Authorization: BearerToken,
      },
    });
  }
}

export const hasuraSubscriptionClient = (bearerToken: string) => {
  return createClient({
    webSocketImpl: ws,
    url: "ws://localhost:8080/v1/graphql",
    connectionParams: {
      headers: {
        Authorization: bearerToken,
      },
    },
  });
};

export async function fetchHasuraSchema(): Promise<string> {
  const query = getIntrospectionQuery();

  const response = await fetch("http://localhost:8080/v1/graphql", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-hasura-admin-secret": process.env.HASURA_GRAPHQL_ADMIN_SECRET!,
    },
    body: JSON.stringify({ query }),
  });

  const { data } = await response.json();

  const introspectionSchema = data.__schema;

  const schema = buildClientSchema({ __schema: introspectionSchema });
  return printSchema(schema);
}