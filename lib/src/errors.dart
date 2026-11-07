/// Erro de negócio que vira uma resposta HTTP com [status] e [message].
class ApiException implements Exception {
  ApiException(this.status, this.message);

  final int status;
  final String message;

  @override
  String toString() => 'ApiException($status): $message';
}
