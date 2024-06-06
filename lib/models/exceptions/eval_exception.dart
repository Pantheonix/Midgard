class EvalException implements Exception {
  EvalException({
    required this.message,
  });

  EvalException.fromJson(Map<String, dynamic> json)
      : message = json['error'] as String;

  final String message;

  Map<String, dynamic> toJson() => {
        'error': message,
      };
}
