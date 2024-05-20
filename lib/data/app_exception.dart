class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix: $_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Error during communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, 'Unauthorized request');
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, 'Forbidden request');
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, 'Requested data not found');
}

class NoInternetException extends AppException {
  NoInternetException([String? message]) : super(message, 'No internet connection');
}
  