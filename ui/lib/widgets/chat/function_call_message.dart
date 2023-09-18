import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/function_call_model.dart';
import '../../providers/function_calls_provider.dart';
import '../../utils/strings.dart';

class FunctionCall extends StatelessWidget {
  final WPTChatMessage message;

  FunctionCall({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final functionCallsStore = Provider.of<FunctionCallsProvider>(context);

    FunctionCallInfo? functionCallInfo = functionCallsStore
        .getFunctionCallInfo(message.functionCall!.functionName);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.code_outlined),
            title: Text(
              camelCaseToSpaceCase(
                  functionCallInfo?.name ?? message.functionCall!.functionName),
              style: const TextStyle(
                fontFamily: 'Courier New',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              functionCallInfo?.description ?? '',
              style: const TextStyle(fontFamily: 'Courier New'),
            ),
          ),
          _buildBody(
            context,
            json.decode(message.functionCall!.parameters),
            functionCallInfo?.parameters.propertiesKeys,
          ),
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

  Widget _buildBody(
    BuildContext context,
    Map<String, dynamic> parameters,
    List<String>? properties,
  ) {
    List<TextSpan> spans = [];

    if (properties != null) {
      for (var property in properties) {
        if (parameters.containsKey(property)) {
          spans.add(
            TextSpan(
              text: "${camelCaseToSpaceCase(property)}:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
          spans.add(
            TextSpan(text: ' ${parameters[property].toString()}'),
          );
        } else {
          spans.add(
            TextSpan(
              text: property,
              style: const TextStyle(color: Colors.grey),
            ),
          );
          spans.add(
            const TextSpan(text: ' -'),
          );
        }
        spans.add(
          const TextSpan(text: '; '),
        );
      }
    }

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
