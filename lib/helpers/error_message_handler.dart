import 'package:dio/dio.dart';

import '../common_widgets/custom_toast.dart';

class ErrorMessageHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _getDioErrorMessage(error);
    } else if (error is FormatException) {
      return "Data format error. Please try again.";
    } else if (error is TypeError) {
      return "Unexpected data received.";
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return "Something went wrong. Please try again.";
    }
  }

  static String _getDioErrorMessage(DioException error) {
    // Handle network-related errors first
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Request timed out. Please check your connection.";

      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";

      case DioExceptionType.badCertificate:
        return "Security certificate error.";

      case DioExceptionType.cancel:
        return "Request was cancelled.";

      case DioExceptionType.badResponse:
        return _getBadResponseErrorMessage(error);

      default:
        return "Network error occurred. Please try again.";
    }
  }

  static String _getBadResponseErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // First try to extract message from JSON response
    if (responseData is Map) {
      final message = responseData['message'] ??
          responseData['error'] ??
          responseData['detail'];
      if (message != null && message is String) {
        return message;
      }

      final dataField = responseData['data'];
      if (dataField is String) {
        if (dataField.contains("No home_barbar found")) {
          return "Aucun barbier trouvé à proximité pour l'instant.";
        }
        return dataField;
      }
    }

    // If no message in JSON, use status code based messages
    switch (statusCode) {
      case 400:
        return "Bad request.";
      case 401:
        return "Session expired. Please login again.";
      case 403:
        return "Access denied.";
      case 404:
        return "Resource not found.";
      case 409:
        return "Conflict occurred.";
      case 422:
        return "Validation failed.";
      case 500:
        return "Internal server error. Please try again later.";
      case 502:
        return "Service temporarily unavailable. Please try again later.";
      case 503:
        return "Service under maintenance. Please try again later.";
      default:
        return "Server error (${statusCode ?? 'unknown'}). Please try again.";
    }
  }

  static void showErrorToast(dynamic error) {
    final message = getErrorMessage(error);
    customToastMessage('Error', message);
  }
}
