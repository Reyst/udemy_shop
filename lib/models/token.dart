import 'package:flutter/foundation.dart';

class Token {
  final String idToken;
  final String email;
  final String refreshToken;
  final DateTime expires;
  final String userId;

  Token({
    @required this.idToken,
    @required this.email,
    @required this.refreshToken,
    @required this.expires,
    @required this.userId,
  });
}

/*
{
"idToken": "[ID_TOKEN]",
"email": "[user@example.com]",
"refreshToken": "[REFRESH_TOKEN]",
"expiresIn": "3600",
"localId": "tRcfmLH7..."
}
*/
