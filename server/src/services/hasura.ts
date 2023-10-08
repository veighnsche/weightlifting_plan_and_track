import { RESTDataSource } from "apollo-datasource-rest";
import { RequestOptions } from "apollo-datasource-rest/src/RESTDataSource";
import { createClient } from "graphql-ws";
import { DocumentNode } from "graphql/language";
import ws from "ws";

export class HasuraRESTDataSource extends RESTDataSource {
  constructor() {
    super();
    this.baseURL = "http://localhost:8080/v1/graphql";
  }

  willSendRequest(request: RequestOptions) {
    if (!process.env.HASURA_GRAPHQL_ADMIN_SECRET) {
      throw new Error("HASURA_GRAPHQL_ADMIN_SECRET not set");
    }
    request.headers.set("x-hasura-admin-secret", process.env.HASURA_GRAPHQL_ADMIN_SECRET!);
  }

  async queryHasura(query: DocumentNode, variables?: Record<string, any>) {
    return this.post("", {
      query: query.loc?.source.body,
      variables: variables,
    });
  }
}

export const hasuraWsClient = () => {
  if (!process.env.HASURA_GRAPHQL_ADMIN_SECRET) {
    throw new Error("HASURA_GRAPHQL_ADMIN_SECRET not set");
  }
  return createClient({
    webSocketImpl: ws,
    url: "ws://localhost:8080/v1/graphql",
    connectionParams: {
      headers: {
        "x-hasura-admin-secret": process.env.HASURA_GRAPHQL_ADMIN_SECRET!,
      },
    },
  });
};