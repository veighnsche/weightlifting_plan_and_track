import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../models/function_call_model.dart';
import '../../providers/function_definition_provider.dart';
import '../../utils/strings.dart';
import 'function_call_body.dart';
import 'function_call_form.dart';

class FunctionCallMessage extends StatelessWidget {
  final WPTChatMessage message;

  const FunctionCallMessage({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final functionDefinition = Provider.of<FunctionDefinitionProvider>(context)
        .getFunctionDefinition(message.functionCall!.functionName);
    final statusAttributes = _getStatusAttributes(message.functionCall!.status);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: statusAttributes.elevation,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: statusAttributes.borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                statusAttributes.icon.icon,
                color: statusAttributes.icon.color,
                size: 24.0,
              ),
              title: Text(
                _getFunctionDisplayName(functionDefinition, message),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: statusAttributes.textColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  functionDefinition?.description ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: statusAttributes.textColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FunctionCallBody(
              arguments: json.decode(message.functionCall?.args ?? '{}'),
              properties: functionDefinition?.parameters.propertiesKeys,
            ),
          ),
          if (message.functionCall?.status == WPTFunctionStatus.pending)
            _buildButtonBar(context, functionDefinition),
          if (message.functionCall?.callback != null &&
              message.functionCall!.callback!.isNotEmpty)
            _buildCallbackSection(statusAttributes.textColor, message),
        ],
      ),
    );
  }

  // Helper method to get the function display name
  String _getFunctionDisplayName(
    FunctionDefinition? functionDefinition,
    WPTChatMessage message,
  ) {
    return camelCaseToSpaceCase(
        functionDefinition?.name ?? message.functionCall?.functionName ?? '');
  }

  // Helper method to build the button bar
  Widget _buildButtonBar(
      BuildContext context, FunctionDefinition? functionDefinition) {
    return ButtonBar(
      alignment: MainAxisAlignment.end,
      children: [
        _buildOutlinedButton(
          onPressed: () {},
          icon: Icon(Icons.close, size: 20.0, color: Colors.grey.shade600),
        ),
        _buildOutlinedButton(
          onPressed: () => _showEditDialog(context, functionDefinition),
          icon: Icon(Icons.check, size: 20.0, color: Colors.grey.shade600),
          label: "Approve",
        ),
        _buildOutlinedButton(
          onPressed: () => _showEditDialog(context, functionDefinition),
          icon: Icon(Icons.edit, size: 20.0, color: Colors.grey.shade600),
          label: "Edit",
        ),
      ],
    );
  }

  // Helper method to build an OutlinedButton
  Widget _buildOutlinedButton({
    required VoidCallback onPressed,
    required Icon icon,
    String? label,
  }) {
    if (label == null || label.isEmpty) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: icon,
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(color: Colors.grey.shade800),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      );
    }
  }

  // Helper method to build the callback section
  Widget _buildCallbackSection(Color textColor, WPTChatMessage message) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.loop,
              color: textColor,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Callback: ${message.functionCall?.callback}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show the edit dialog
  void _showEditDialog(
      BuildContext context, FunctionDefinition? functionCallInfo) {
    if (functionCallInfo == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getFunctionDisplayName(functionCallInfo, message)),
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

  // Helper method to get status attributes
  StatusAttributes _getStatusAttributes(WPTFunctionStatus status) {
    final statusMap = {
      WPTFunctionStatus.pending: StatusAttributes(
        textColor: Colors.blueGrey,
        borderColor: Colors.blueGrey.shade200,
        icon: const Icon(Icons.input, color: Colors.blueGrey),
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

    return statusMap[status]!;
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
