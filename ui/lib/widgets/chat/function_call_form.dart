import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/models/chat_model.dart';
import 'package:weightlifting_plan_and_track/models/function_call_model.dart';
import 'package:weightlifting_plan_and_track/utils/strings.dart';

class FunctionCallForm extends StatefulWidget {
  final FunctionDefinition? functionCallInfo;
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
      _parsedParameters = json.decode(widget.functionCall!.args);
    } else {
      _parsedParameters = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _buildFormFields(),
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
    bool isRequired =
        widget.functionCallInfo!.parameters.required.contains(key);

    if (property.enumValues != null && property.enumValues!.isNotEmpty) {
      String? dropdownValue = _parsedParameters[key]?.toString();

      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: dropdownValue,
              decoration: InputDecoration(
                labelText: camelCaseToSpaceCase(key),
                helperText: property.description,
              ),
              items: property.enumValues!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return '$key is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _parsedParameters[key] = value;
                });
              },
            ),
          ),
          if (!isRequired)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.clear, size: 18.0, color: Colors.grey[400]),
                onPressed: () {
                  setState(() {
                    _parsedParameters[key] = null;
                  });
                },
                tooltip: 'Clear selection',
              ),
            ),
        ],
      );
    } else {
      return TextFormField(
        initialValue: _parsedParameters[key]?.toString(),
        keyboardType: property.type == 'number' ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: camelCaseToSpaceCase(key),
          helperText: property.description,
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$key is required';
          }
          if (property.type == 'number' && value != null && value.isNotEmpty && !isNumeric(value)) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onSaved: (value) {
          _parsedParameters[key] = value;
        },
      );
    }
  }
}

bool isNumeric(String value) {
  return num.tryParse(value) != null;
}
