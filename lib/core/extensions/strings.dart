extension CamelCaseSplitter on String {
  String splitCamelCase() {
    return replaceAllMapped(
      RegExp(r'(?<!^)([A-Z])'),
          (Match match) => ' ${match.group(1)}',
    );
  }
}
