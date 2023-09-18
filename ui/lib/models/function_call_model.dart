class FunctionCallInfo {
  final String name;
  final String description;
  final Parameters parameters;

  FunctionCallInfo({
    required this.name,
    required this.description,
    required this.parameters,
  });

  factory FunctionCallInfo.fromMap(Map<String, dynamic> map) {
    return FunctionCallInfo(
      name: map['name'],
      description: map['description'],
      parameters: Parameters.fromMap(map['parameters']),
    );
  }

  static List<FunctionCallInfo> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => FunctionCallInfo.fromMap(map)).toList();
  }
}


class Parameters {
  final String type;
  final Map<String, FunctionCallProperty> properties;
  final List<String> required;

  Parameters({
    required this.type,
    required this.properties,
    required this.required,
  });

  factory Parameters.fromMap(Map<String, dynamic> map) {
    Map<String, FunctionCallProperty> propertiesMap = {};
    if (map['properties'] != null) {
      map['properties'].forEach((key, value) {
        propertiesMap[key] = FunctionCallProperty.fromMap(value);
      });
    }

    return Parameters(
      type: map['type'],
      properties: propertiesMap,
      required: List<String>.from(map['required']),
    );
  }
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
}