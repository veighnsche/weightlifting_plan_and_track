import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'auth_service.dart';

class GraphQLService {
  final AuthService _authService = AuthService();

  GraphQLClient? _wsClient;
  GraphQLClient? _httpClient;

  GraphQLClient get wsClient {
    _wsClient ??= _wsConnect();
    return _wsClient!;
  }

  GraphQLClient get httpClient {
    _httpClient ??= _httpConnect();
    return _httpClient!;
  }

  GraphQLClient _wsConnect() {
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

  GraphQLClient _httpConnect() {
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

  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return wsClient.subscribe(options).map((event) {
      if (event.hasException) {
        if (kDebugMode) {
          print("GraphQL Exception: ${event.exception}");
        }
        throw event.exception!;
      }
      return event;
    });
  }

  Future<QueryResult> query(QueryOptions options) {
    return httpClient.query(options);
  }
}
