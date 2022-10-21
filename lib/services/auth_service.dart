import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final String _baseUrl = 'https://identitytoolkit.googleapis.com/';
  final String _firebaseToken = 'AIzaSyB09VtRHuir4AqDHQgeiRb_fymH0dPG4tk';
  final String _endPoint = '/v1/accounts';
  var dio = Dio();

  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    try {
      final url = '$_baseUrl$_endPoint:signUp?key=$_firebaseToken';

      final resp = await dio.post(url, queryParameters: authData);
      if (resp.data.containsKey('idToken')) {
        await storage.write(key: 'token', value: resp.data['idToken']);

        return null;
      }
    } on DioError catch (e) {
      return e.response!.data['error']['message'];
    }
    return null;
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      final Map<String, dynamic> authData = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };

      final url = '$_baseUrl$_endPoint:signInWithPassword?key=$_firebaseToken';

      final resp = await dio.post(url, queryParameters: authData);
      if (resp.data.containsKey('idToken')) {
        resp.data['idToken'];
        await storage.write(key: 'token', value: resp.data['idToken']);
        await storage.write(key: 'email', value: email);
        return null;
      }
    } on DioError catch (e) {
      return e.response!.data['error']['message'];
    }
    return null;
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
