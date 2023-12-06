class AuthException implements Exception {
  AuthException(this.statusCode, this.message, this.errors);

  AuthException.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] as int,
        message = json['message'] as String,
        errors = Errors.fromJson(json['errors'] as Map<String, dynamic>);

  final int statusCode;
  final String message;
  final Errors errors;

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'errors': errors.toJson(),
      };
}

class Errors {
  Errors(this.generalErrors);

  Errors.fromJson(Map<String, dynamic> json)
      : generalErrors = json['GeneralErrors'] as List<dynamic>;

  final List<dynamic> generalErrors;

  String get asString => generalErrors.join();

  Map<String, dynamic> toJson() => {
        'GeneralErrors': generalErrors,
      };
}
