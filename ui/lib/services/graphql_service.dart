import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'auth_service.dart';

class GraphQLService {
  final AuthService _authService = AuthService();

  GraphQLClient? _client;

  GraphQLClient get client {
    _client ??= _connect();
    return _client!;
  }

  GraphQLClient _connect() {
    final websocketLink = WebSocketLink(
      'ws://localhost:8080/v1/graphql',
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: () async {
          final token = await _authService.token;
          return {
            'headers': {
              'Authorization': 'Bearer $token',
            },
          };
        },
      ),
    );

    final link = Link.split(
          (request) => request.isSubscription,
      websocketLink,
    );

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return client.subscribe(options).map((event) {
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
