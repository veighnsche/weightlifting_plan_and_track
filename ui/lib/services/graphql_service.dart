import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import 'auth_service.dart';

class GraphQLService {
  final AuthService _authService = AuthService();

  GraphQLClient? _wsClientDeprecated;
  GraphQLClient? _httpClientDeprecated;

  GraphQLClient? _wsClient;

  GraphQLClient get wsClientDeprecated {
    _wsClientDeprecated ??= _wsConnectDeprecated();
    return _wsClientDeprecated!;
  }

  GraphQLClient get httpClientDeprecated {
    _httpClientDeprecated ??= _httpConnectDeprecated();
    return _httpClientDeprecated!;
  }

  GraphQLClient get wsClient {
    _wsClient ??= _wsConnect();
    return _wsClient!;
  }

  GraphQLClient _wsConnectDeprecated() {
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

    return GraphQLClient(
      cache: GraphQLCache(),
      link: websocketLink,
    );
  }

  GraphQLClient _wsConnect() {
    final websocketLink = WebSocketLink(
      'ws://localhost:3000/graphql',
      config: SocketClientConfig(
        autoReconnect: false,
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

    return GraphQLClient(
      cache: GraphQLCache(),
      link: websocketLink,
    );
  }

  GraphQLClient _httpConnectDeprecated() {
    final httpLink = HttpLink('http://localhost:8080/v1/graphql');

    final authLink = AuthLink(
      getToken: () async {
        final token = await _authService.token;
        return 'Bearer $token';
      },
    );

    final link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  Stream<QueryResult> subscribeDeprecated(SubscriptionOptions options) {
    return wsClientDeprecated.subscribe(options).map((event) {
      if (event.hasException) {
        if (kDebugMode) {
          print("GraphQL Exception: ${event.exception}");
        }
        throw event.exception!;
      }
      return event;
    });
  }

  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return wsClient.subscribe(options).map((event) {
      print('event $event');
      if (event.hasException) {
        if (kDebugMode) {
          print("GraphQL Exception: ${event.exception}");
        }
        throw event.exception!;
      }
      return event;
    });
  }

  Future<QueryResult> queryDeprecated(QueryOptions options) {
    return httpClientDeprecated.query(options);
  }
}
