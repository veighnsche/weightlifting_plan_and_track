import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FutureStreamBuilder<T> extends StatelessWidget {
  final Future<Stream<T>> futureStream;
  final Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  const FutureStreamBuilder({super.key, required this.futureStream, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<T>>(
      future: futureStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Center(child: Text('Error'));
        }

        return StreamBuilder<T>(
          stream: snapshot.data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              if (kDebugMode) {
                print(snapshot.error);
              }
              return const Center(child: Text('Error'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            return builder(context, snapshot);
          },
        );
      },
    );
  }
}
