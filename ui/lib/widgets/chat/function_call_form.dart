import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/models/chat_model.dart';
import 'package:weightlifting_plan_and_track/models/function_call_model.dart';
import 'package:weightlifting_plan_and_track/utils/strings.dart';

class FunctionCallForm extends StatefulWidget {
  final FunctionCallInfo? functionCallInfo;
  final WPTFunctionCall? functionCall;

  const FunctionCallForm({
    super.key,
    this.functionCallInfo,
    this.functionCall,
  });

  @override
  State<FunctionCallForm> createState() => _FunctionCallFormState();
}

class _FunctionCallFormState extends State<FunctionCallForm> {
  late Map<String, dynamic> _parsedParameters;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.functionCall != null) {
      _parsedParameters = json.decode(widget.functionCall!.parameters);
    } else {
      _parsedParameters = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ..._buildFormFields(),
          // Optional: Add action buttons here if you want them within the form widget
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     TextButton(onPressed: _cancel, child: Text('Cancel')),
          //     TextButton(onPressed: _save, child: Text('Save')),
          //   ],
          // ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [];
    widget.functionCallInfo?.parameters.properties.forEach((key, property) {
      fields.add(_buildFormField(key, property));
    });
    return fields;
  }

  Widget _buildFormField(String key, FunctionCallProperty property) {
    return TextFormField(
      initialValue: _parsedParameters[key]?.toString(),
      decoration: InputDecoration(
        labelText: camelCaseToSpaceCase(key),
        helperText: property.description,
      ),
      validator: (value) {
        if (widget.functionCallInfo!.parameters.required.contains(key) &&
            (value == null || value.isEmpty)) {
          return '$key is required';
        }
        // Additional validation based on property.type can be added here
        return null;
      },
      onSaved: (value) {
        _parsedParameters[key] = value;
      },
    );
  }
}
