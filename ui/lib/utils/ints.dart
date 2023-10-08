extension CustomToString on num {
  String toCustomString() {
    String formatted = toDouble().toStringAsFixed(1);
    return formatted.endsWith('.0') ? formatted.split('.')[0] : formatted;
  }
}