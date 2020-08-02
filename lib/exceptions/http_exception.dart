class HttpExeception implements Exception {
  final String message;

  HttpExeception(this.message);

  @override
  String toString() {
    return "$message";
  }
}
