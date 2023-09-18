import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/models/function_call_model.dart';
import 'package:weightlifting_plan_and_track/services/function_calls_store.dart';

import '../../models/chat_model.dart';
import '../../utils/strings.dart';

class FunctionCall extends StatelessWidget {
  final FunctionCallsStore _functionCallsStore = FunctionCallsStore();

  final WPTChatMessage message;

  FunctionCall({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    FunctionCallInfo? functionCallInfo =
        _functionCallsStore.getFunctionCallInfo(message.functionCall!.functionName);

    print(functionCallInfo?.name);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.code_outlined),
            title: Text(
              camelCaseToSpaceCase(functionCallInfo?.name ?? message.functionCall!.functionName),
              style: const TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _buildBody(context, json.decode(message.functionCall!.parameters)),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.close),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check),
                label: const Text("Approve"),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> parameters) {
    List<TextSpan> spans = [];

    parameters.forEach((key, value) {
      spans.add(
        TextSpan(
          text: key,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      spans.add(
        TextSpan(text: ' ${value.toString()}'),
      );

      spans.add(
        const TextSpan(text: '; '),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: spans,
        ),
      ),
    );
  }
}
