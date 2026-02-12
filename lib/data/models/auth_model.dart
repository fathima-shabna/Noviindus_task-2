class AuthResponse {
  final String? access;
  final String? refresh;
  final String? status;

  AuthResponse({this.access, this.refresh, this.status});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final tokenData = json['token'] as Map<String, dynamic>?;
    return AuthResponse(
      access: tokenData?['access'],
      refresh: tokenData?['refresh'],
      status: json['status']?.toString(),
    );
  }
}
