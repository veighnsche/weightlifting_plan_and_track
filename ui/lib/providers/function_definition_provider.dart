import 'package:flutter/foundation.dart';

import '../models/function_call_model.dart';

class FunctionDefinitionProvider extends ChangeNotifier {
  final List<FunctionDefinition> _functionDefinitions = [];

  List<FunctionDefinition> get functionDefinitions => _functionDefinitions;

  void setFunctionDefinitions(List<dynamic> functionCallsInfo) {
    _functionDefinitions.clear();
    _functionDefinitions
        .addAll(FunctionDefinition.fromMapList(functionCallsInfo));
    notifyListeners();
  }

  FunctionDefinition? getFunctionDefinition(String name) {
    try {
      return _functionDefinitions
          .firstWhere((functionDefinition) => functionDefinition.name == name);
    } catch (e) {
      return null;
    }
  }
}
