import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/constants.dart';
import '../models/token.dart';

class AuthProvider with ChangeNotifier {
  static const _KEY_TOKEN = 'token';

  Token _token;

  bool get isLoggedIn {
    // print("INSPECT: $_token, ${DateTime.now().isBefore(_token.expires)}");

    return _token != null && DateTime.now().isBefore(_token?.expires ?? 0);
  }

  Token get token => _token;

  Timer _logoutTimer;

  Future<bool> register(String email, String password) async {
    return _authenticate(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY',
      email,
      password,
    );
  }

  Future<bool> login(String email, String password) async {
    return _authenticate(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY',
      email,
      password,
    );
  }

  Future<bool> _authenticate(String url, String email, String password) async {
    final response = await Http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print("INSPECT: ${response.body}");
    final responseData = json.decode(response.body);

    if (response.statusCode >= 400) throw Exception(responseData['error']['message']);

    print("INSPECT: $responseData");

    _token = Token(
      idToken: responseData['idToken'],
      email: responseData['email'],
      refreshToken: responseData['refreshToken'],
      expires: DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      ),
      userId: responseData['localId'],
    );

    notifyListeners();

    _saveToken();
    _setAutoLogout();

    return true;
  }

  Future<void> _saveToken() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
      _KEY_TOKEN,
      json.encode(
        {
          'idToken': _token.idToken,
          'email': _token.email,
          'refreshToken': _token.refreshToken,
          'expires': _token.expires.microsecondsSinceEpoch,
          'userId': _token.userId,
        },
      ),
    );
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_KEY_TOKEN);
    notifyListeners();
  }

  Future<bool> autoLogin() async {

    final tokenJson = (await SharedPreferences.getInstance()).getString(_KEY_TOKEN);

    if (tokenJson == null) return false;

    final tokenData = json.decode(tokenJson);
    if (tokenData['expires'] == null) return false;

    final expires = DateTime.fromMicrosecondsSinceEpoch(tokenData['expires']);
    if (!DateTime.now().isBefore(expires)) return false;

    _token = Token(
      idToken: tokenData['idToken'],
      email: tokenData['email'],
      refreshToken: tokenData['refreshToken'],
      expires: expires,
      userId: tokenData['userId'],
    );
    notifyListeners();

    _saveToken();
    _setAutoLogout();
    return true;
  }

  void _setAutoLogout() {
    _logoutTimer?.cancel();

    _logoutTimer = Timer(
      Duration(seconds: _token.expires.difference(DateTime.now()).inSeconds),
      logout,
    );
  }
}
