String camelCaseToSpaceCase(String input) {
  if (input.isEmpty) return "";

  // Insert a space before each uppercase letter
  String spaced = input.replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])'), (Match m) => ' ${m[0]}');

  // Convert the entire string to lowercase and then capitalize the first letter
  return '${spaced[0].toUpperCase()}${spaced.substring(1).toLowerCase()}';
}
