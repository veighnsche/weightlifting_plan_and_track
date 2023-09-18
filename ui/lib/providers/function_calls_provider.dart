import 'package:flutter/foundation.dart';

import '../models/function_call_model.dart';

class FunctionCallsProvider extends ChangeNotifier {
  final List<FunctionCallInfo> _functionCalls = [];

  List<FunctionCallInfo> get functionCalls => _functionCalls;

  void setFunctionCallsInfo(List<dynamic> functionCallsInfo) {
    _functionCalls.clear();
    _functionCalls.addAll(FunctionCallInfo.fromMapList(functionCallsInfo));
    notifyListeners();
  }

  FunctionCallInfo? getFunctionCallInfo(String name) {
    try {
      return _functionCalls
          .firstWhere((functionCall) => functionCall.name == name);
    } catch (e) {
      return null;
    }
  }
}
