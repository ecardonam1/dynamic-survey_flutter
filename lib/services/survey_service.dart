import 'package:chamitosapp/models/survey.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SurveyService {
  final String _baseUrl = 'https://chamitosapp-default-rtdb.firebaseio.com/';

  final String _endPoint = 'surveys.json';
  var dio = Dio();

  final storage = const FlutterSecureStorage();

  Future saveOrCreateSurvey() async {}

  Future createSurvey(Survey survey) async {
    survey.user = await storage.read(key: 'email') ?? '';
    try {
      final url = '$_baseUrl$_endPoint';
      final resp = await dio.post(
        url,
        data: survey.toJson(),
      );

      if (resp.data.containsKey('idToken')) {
        await storage.write(key: 'token', value: resp.data['idToken']);

        return null;
      }
    } on DioError catch (e) {
      return e.response!.data['error']['message'];
    }
    return null;
  }
}
