import 'package:equatable/equatable.dart';

final class TokenMd extends Equatable {
  //{
  //     "access_token": "N2FiMTIyOWE0NTkyMTBiMzU5OTNmMzdlMWM5MGE0ZjRlMDFmMTFkZWYzZTQ2YjNlNWE2ZjRjZDQ5MDgwNzE1NQ",
  //     "expires_in": 600,
  //     "token_type": "bearer",
  //     "scope": null,
  //     "refresh_token": "N2FhODNlMTJmNTBiNWRjNWUyYzI4Y2QxYTJjYzQzNDVmNmYzOTNmNmU4YzBjYjY2ZGM5NThjY2FlMDYwNjVjYw"
  // }

  final String accessToken;
  final num expiresIn;
  final String tokenType;
  final String refreshToken;

  const TokenMd({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.refreshToken,
  });

  factory TokenMd.fromJson(Map<String, dynamic> json) {
    return TokenMd(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['token_type'] = tokenType;
    data['refresh_token'] = refreshToken;
    return data;
  }

  @override
  List<Object?> get props =>
      [accessToken, expiresIn, tokenType,  refreshToken];
}
