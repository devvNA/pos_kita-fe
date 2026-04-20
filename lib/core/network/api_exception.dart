// lib/core/network/api_exception.dart

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({this.statusCode, required this.message, this.data});

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection or request timeout.',
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
  }) : super(statusCode: 401);
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Resource not found.'})
    : super(statusCode: 404);
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Internal server error. Please try again later.',
  }) : super(statusCode: 500);
}
