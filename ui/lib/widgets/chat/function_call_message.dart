import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/function_call_model.dart';
import '../../providers/function_calls_provider.dart';
import '../../utils/strings.dart';
import 'function_call_body.dart';
import 'function_call_form.dart';

class FunctionCallMessage extends StatelessWidget {
  final WPTChatMessage message;

  const FunctionCallMessage({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final functionCallsStore = Provider.of<FunctionCallsProvider>(context);
    final functionCallInfo = functionCallsStore
        .getFunctionCallInfo(message.functionCall?.functionName ?? '');
    final statusAttributes = _statusAttributes(message.functionCall?.status);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: statusAttributes.elevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: statusAttributes.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                statusAttributes.icon.icon,
                color: statusAttributes.icon.color,
                size: 28.0,
              ),
              title: Text(
                camelCaseToSpaceCase(functionCallInfo?.name ??
                    message.functionCall?.functionName ??
                    ''),
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: statusAttributes.textColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  functionCallInfo?.description ?? '',
                  style: TextStyle(
                    fontFamily: 'Courier New',
                    fontSize: 14.0,
                    color: statusAttributes.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            FunctionCallBody(
              parameters: json.decode(message.functionCall?.parameters ?? '{}'),
              properties: functionCallInfo?.parameters.propertiesKeys,
            ),
            const SizedBox(height: 12.0),
            if (message.functionCall?.status == WPTFunctionStatus.pending)
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400, width: 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey.shade800,
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showEditDialog(context, functionCallInfo),
                    icon: Icon(
                      Icons.edit,
                      size: 20.0,
                      color: Colors.grey.shade600,
                    ),
                    label: Text(
                      "Edit",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                      // Thinner and neutral border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  StatusAttributes _statusAttributes(WPTFunctionStatus? status) {
    final defaultAttributes = StatusAttributes(
      textColor: Colors.black,
      borderColor: Colors.black26,
      icon: const Icon(Icons.help_outline, color: Colors.black26),
      elevation: 1.0,
    );

    final statusMap = {
      WPTFunctionStatus.pending: StatusAttributes(
        textColor: Colors.blueGrey,
        borderColor: Colors.blueGrey.shade200,
        icon: const Icon(Icons.input, color: Colors.blueGrey),
        // Changed to 'input' icon
        elevation: 4.0,
      ),
      WPTFunctionStatus.expired: StatusAttributes(
        textColor: Colors.grey,
        borderColor: Colors.grey.shade300,
        icon: const Icon(Icons.timer_off, color: Colors.grey),
        elevation: 1.0,
      ),
      WPTFunctionStatus.approved: StatusAttributes(
        textColor: Colors.green,
        borderColor: Colors.green.shade200,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        elevation: 1.0,
      ),
      WPTFunctionStatus.rejected: StatusAttributes(
        textColor: Colors.red,
        borderColor: Colors.red.shade200,
        icon: const Icon(Icons.cancel, color: Colors.red),
        elevation: 1.0,
      ),
      WPTFunctionStatus.none: StatusAttributes(
        textColor: Colors.black,
        borderColor: Colors.black26,
        icon: const Icon(Icons.search, color: Colors.black26),
        elevation: 1.0,
      ),
    };

    return statusMap[status] ?? defaultAttributes;
  }

  void _showEditDialog(
      BuildContext context, FunctionCallInfo? functionCallInfo) {
    if (functionCallInfo == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(camelCaseToSpaceCase(functionCallInfo.name)),
        content: SingleChildScrollView(
          child: FunctionCallForm(
            functionCallInfo: functionCallInfo,
            functionCall: message.functionCall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle save logic here
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class StatusAttributes {
  final Color textColor;
  final Color borderColor;
  final Icon icon;
  final double elevation;

  StatusAttributes({
    required this.textColor,
    required this.borderColor,
    required this.icon,
    required this.elevation,
  });
}
