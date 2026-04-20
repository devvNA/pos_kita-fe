// lib/core/network/api_response.dart

class ApiResponse<T> {
  final int statusCode;
  final String? message;
  final T? data;
  final bool success;

  const ApiResponse({
    required this.statusCode,
    this.message,
    this.data,
    required this.success,
  });

  factory ApiResponse.success({
    required int statusCode,
    T? data,
    String? message,
  }) {
    return ApiResponse(
      statusCode: statusCode,
      data: data,
      message: message,
      success: true,
    );
  }

  factory ApiResponse.error({required int statusCode, String? message}) {
    return ApiResponse(
      statusCode: statusCode,
      message: message,
      success: false,
    );
  }

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, success: $success, message: $message)';
}
