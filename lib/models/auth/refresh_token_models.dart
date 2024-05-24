class RefreshTokenRequest {
  RefreshTokenRequest({
    required this.userId,
  });

  RefreshTokenRequest.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String;

  final String userId;

  Map<String, dynamic> toJson() => {
        'userId': userId,
      };
}
