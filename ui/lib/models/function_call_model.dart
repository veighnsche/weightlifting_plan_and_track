class FunctionCallInfo {
  final String name;
  final String description;
  final FunctionCallParameters parameters;

  FunctionCallInfo({
    required this.name,
    required this.description,
    required this.parameters,
  });

  factory FunctionCallInfo.fromMap(Map<String, dynamic> map) {
    return FunctionCallInfo(
      name: map['name'],
      description: map['description'],
      parameters: FunctionCallParameters.fromMap(map['parameters']),
    );
  }

  static List<FunctionCallInfo> fromMapList(List<dynamic> mapList) {
    return mapList.map((map) => FunctionCallInfo.fromMap(map)).toList();
  }
}

class FunctionCallParameters {
  final String type;
  final Map<String, FunctionCallProperty> properties;
  final List<String> required;

  FunctionCallParameters({
    required this.type,
    required this.properties,
    required this.required,
  });

  factory FunctionCallParameters.fromMap(Map<String, dynamic> map) {
    return FunctionCallParameters(
      type: map['type'],
      properties: FunctionCallProperty.propertiesFromMap(map['properties'] ?? {}),
      required: List<String>.from(map['required']),
    );
  }

  FunctionCallProperty? getProperty(String key) {
    return properties[key];
  }

  List<String> get propertiesKeys => properties.keys.toList();
}

class FunctionCallProperty {
  final String type;
  final String? description;
  final List<String>? enumValues;

  FunctionCallProperty({
    required this.type,
    this.description,
    this.enumValues,
  });

  factory FunctionCallProperty.fromMap(Map<String, dynamic> map) {
    return FunctionCallProperty(
      type: map['type'],
      description: map['description'],
      enumValues: map['enum'] != null ? List<String>.from(map['enum']) : null,
    );
  }

  static Map<String, FunctionCallProperty> propertiesFromMap(Map<String, dynamic> propertiesMap) {
    Map<String, FunctionCallProperty> result = {};
    propertiesMap.forEach((key, value) {
      result[key] = FunctionCallProperty.fromMap(value);
    });
    return result;
  }
}
