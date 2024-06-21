class CustomException implements Exception {
  final String message;
  final String? prefix;

  CustomException({required this.message, this.prefix});

  @override
  String toString() => "$message$prefix";
}

class NoUseSign implements Exception {
  final String message = "You are current not authenticated.";

  NoUseSign();

  @override
  String toString() => message;
}
