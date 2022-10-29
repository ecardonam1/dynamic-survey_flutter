import 'package:chamitosapp/models/survey.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SurveyService {
  final String _baseUrl = 'https://chamitosapp-default-rtdb.firebaseio.com';

  final String _endPoint = 'surveys.json';
  var dio = Dio();

  final storage = const FlutterSecureStorage();

  Future saveOrCreateSurvey() async {}

  Future<List<Survey>> getSurveysByUser() async {
    String user = await storage.read(key: 'email') ?? '';
    List<Survey> surveys = [];
    try {
      final url = '$_baseUrl/$_endPoint';

      final resp = await dio.get(url);
      resp.data.forEach((key, value) {
        if (value['user'] == user) {
          surveys.add(Survey.fromMap(value).copyWith(key: key));
        }
      });
      return surveys;
    } on DioError catch (e) {
      return (e.response != null)
          ? e.response!.data['error']['message']
          : e.response;
    }
  }

  Future<Survey?> getSurveyByCode(String code) async {
    try {
      final url = '$_baseUrl/$_endPoint';

      final resp = await dio.get(url);
      Survey? tempSurvey;
      resp.data.forEach((key, value) {
        if (code == value['code']) {
          tempSurvey = Survey.fromMap(value);
          tempSurvey = tempSurvey!.copyWith(key: key);
        }
      });
      return tempSurvey;
    } on DioError catch (e) {
      return (e.response != null)
          ? e.response!.data['error']['message']
          : e.response;
    }
  }

  Future saveSurvey(Survey survey) async {
    try {
      final url = '$_baseUrl/$_endPoint';

      final resp = await dio.get(url);
      String tempKey = '';
      resp.data.forEach((key, value) {
        if (survey.code == value['code']) {
          tempKey = key;
        }
      });

      final urlS = '$_baseUrl/surveys/$tempKey.json';

      await dio.put(
        urlS,
        data: survey.toJson(),
      );
      return survey.toJson();
    } on DioError catch (e) {
      return (e.response != null)
          ? e.response!.data['error']['message']
          : e.response;
    }
  }

  Future createSurvey(Survey survey) async {
    String user = await storage.read(key: 'email') ?? '';
    survey = survey.copyWith(user: user);
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
      return (e.response != null)
          ? e.response!.data['error']['message']
          : e.response;
    }
  }
}
