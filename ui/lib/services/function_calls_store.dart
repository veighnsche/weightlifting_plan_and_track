import '../models/function_call_model.dart';

class FunctionCallsStore {
  FunctionCallsStore._privateConstructor();

  static final FunctionCallsStore _instance =
      FunctionCallsStore._privateConstructor();

  factory FunctionCallsStore() {
    return _instance;
  }

  final List<FunctionCallInfo> _functionCalls = [];

  List<FunctionCallInfo> get functionCalls => _functionCalls;

  void setFunctionCallsInfo(List<Map<String, dynamic>> functionCallsInfo) {
    _functionCalls.clear();
    _functionCalls.addAll(FunctionCallInfo.fromMapList(functionCallsInfo));
  }

  FunctionCallInfo? getFunctionCallInfo(String name) {
    print(_functionCalls);
    try {
      return _functionCalls.firstWhere((functionCall) => functionCall.name == name);
    } catch (e) {
      return null;
    }
  }
}
