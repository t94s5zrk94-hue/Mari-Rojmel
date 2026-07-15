class ParsedEntry {
  const ParsedEntry({
    required this.amount,
    required this.categoryId,
    required this.isIncome,
    required this.description,
  });

  final double amount;

  final int categoryId;

  final bool isIncome;

  final String description;

  @override
  String toString() {
    return '''
Amount      : $amount
Category ID : $categoryId
Income      : $isIncome
Description : $description
''';
  }
}