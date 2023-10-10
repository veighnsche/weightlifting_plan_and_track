import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import 'auth_service.dart';

class GraphQLService {
  final AuthService _authService = AuthService();

  GraphQLClient? _client;

  Future<GraphQLClient> get client async {
    _client ??= await _connect();
    return _client!;
  }

  Future<GraphQLClient> _connect() async {
    // HTTP Link
    final httpLink = HttpLink('http://localhost:3000/graphql');

    // Authentication Link
    final authLink = AuthLink(
      getToken: () async {
        final token = await _authService.token;
        return 'Bearer $token';
      },
    );

    // WebSockets Link
    final WebSocketLink websocketLink = WebSocketLink(
      'ws://localhost:3000/graphql',
      subProtocol: 'graphql-transport-ws', /** DO NOT TOUCH! This is required! even though it's not even the right value */
      config: SocketClientConfig(
        autoReconnect: true,
        delayBetweenReconnectionAttempts: const Duration(seconds: 15),
        inactivityTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer ${await _authService.token}',
        },
      ),
    );


    // Combining both links with a split function
    // If the request is a subscription, it uses the WebSockets link.
    // Otherwise, it defaults to the HTTP link.
    final link = Link.split(
      (request) => request.isSubscription,
      websocketLink,
      authLink.concat(httpLink),
    );

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  Future<Stream<QueryResult>> subscribe(SubscriptionOptions options) async {
    return (await client).subscribe(options).map((event) {
      if (event.hasException) {
        if (kDebugMode) {
          print("GraphQL Exception: ${event.exception}");
        }
        throw event.exception!;
      }
      return event;
    });
  }
}
