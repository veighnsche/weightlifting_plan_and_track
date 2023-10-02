import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import 'auth_service.dart';

class GraphQLService {
  final AuthService _authService = AuthService();

  GraphQLClient _connect() {
    final httpLink = HttpLink('http://localhost:8080/v1/graphql');

    final websocketLink = WebSocketLink(
      'ws://localhost:8080/v1/graphql',
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

    final authLink = AuthLink(getToken: () async {
      final token = await _authService.token;
      return 'Bearer $token';
    });

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

  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return _connect().subscribe(options).map((event) {
      if (event.hasException) {
        if (kDebugMode) {
          print(event.exception);
        }
        throw event.exception!;
      }
      return event;
    });
  }
}
