class ProblemException implements Exception {
  ProblemException(
    this.message,
    this.details,
    this.validationErrors,
  );

  ProblemException.fromJson(Map<String, dynamic> json)
      : message = json['error']['message'] as String,
        details = json['error']['details'] as String?,
        validationErrors = json['error']['validationErrors'] != null
            ? (json['error']['validationErrors'] as List<dynamic>)
                .map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
                .toList()
            : [];

  final String message;
  final String? details;
  final List<ValidationError> validationErrors;

  Map<String, dynamic> toJson() => {
        'message': message,
        'details': details,
        'validationErrors': validationErrors.map((e) => e.toJson()).toList(),
      };
}

class ValidationError {
  ValidationError(
    this.message,
    this.members,
  );

  ValidationError.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String,
        members =
            (json['members'] as List<dynamic>).map((e) => e as String).toList();

  final String message;
  final List<String> members;

  Map<String, dynamic> toJson() => {
        'message': message,
        'members': members,
      };
}
