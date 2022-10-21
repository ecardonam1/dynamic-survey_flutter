import 'package:chamitosapp/models/survey.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SurveyService {
  final String _baseUrl = 'https://chamitosapp-default-rtdb.firebaseio.com';

  final String _endPoint = 'surveys.json';
  var dio = Dio();

  final storage = const FlutterSecureStorage();

  Future saveOrCreateSurvey() async {}

  Future getSurveyByCode(String code) async {
    try {
      final url = '$_baseUrl/$_endPoint';

      final resp = await dio.get(url);
      Survey? tempSurvey;
      resp.data.forEach((key, value) {
        if (code == value['code']) {
          tempSurvey = Survey.fromMap(value);
        }
      });
      return tempSurvey;
    } on DioError catch (e) {
      return e.response!.data['error']['message'];
    }
  }

  Future saveSurveyByCode(String code) async {
    try {
      final url = '$_baseUrl/$_endPoint';

      final resp = await dio.get(url);
      Survey? tempSurvey;
      String tempKey = '';
      resp.data.forEach((key, value) {
        if (code == value['code']) {
          tempSurvey = Survey.fromMap(value);
        }
      });

      final urlS = '$_baseUrl/surveys/$tempKey.json';

      await dio.put(
        urlS,
        data: tempSurvey!.toJson(),
      );
      return tempSurvey;
    } on DioError catch (e) {
      return e.response!.data['error']['message'];
    }
  }

  Future createSurvey(Survey survey) async {
    survey.user = await storage.read(key: 'email') ?? '';
    try {
      final url = '$_baseUrl/$_endPoint';
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
