import 'package:flutter/material.dart';

import '../../utils/strings.dart';

class FunctionCallBody extends StatelessWidget {
  final Map<String, dynamic> arguments;
  final List<String>? properties;

  const FunctionCallBody({
    super.key,
    required this.arguments,
    this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
        },
        children: _generateTableRows(),
      ),
    );
  }

  List<TableRow> _generateTableRows() {
    List<TableRow> rows = [];

    if (properties != null) {
      rows.addAll(_processProperties());
    }
    rows.addAll(_processDeprecatedParameters());

    return rows;
  }

  List<TableRow> _processProperties() {
    List<TableRow> rows = [];
    for (var property in properties!) {
      if (arguments.containsKey(property)) {
        rows.add(TableRow(children: [
          _boldTableCell("${camelCaseToSpaceCase(property)}:"),
          _normalTableCell(arguments[property].toString()),
        ]));
      } else {
        rows.add(TableRow(children: [
          _greyTableCell("${camelCaseToSpaceCase(property)}:"),
          _normalTableCell('-'),
        ]));
      }
    }
    return rows;
  }

  List<TableRow> _processDeprecatedParameters() {
    List<TableRow> rows = [];
    for (var key in arguments.keys) {
      if (properties == null || !properties!.contains(key)) {
        rows.add(TableRow(children: [
          _italicGreyTableCell("${camelCaseToSpaceCase(key)}:"),
          _normalTableCell(arguments[key].toString()),
        ]));
      }
    }
    return rows;
  }

  Widget _boldTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _normalTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text),
    );
  }

  Widget _greyTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _italicGreyTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
      ),
    );
  }
}
