import 'package:chamitosapp/models/survey.dart';
import 'package:chamitosapp/services/services.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(bool short, String code) async {
    String linkMessage;
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      link: Uri.parse("https://www.chamitosapp.com/survey?code=$code"),
      uriPrefix: "https://chamitosapp.page.link",
      androidParameters:
          const AndroidParameters(packageName: "com.example.chamitosapp"),
      iosParameters: const IOSParameters(bundleId: "com.example.chamitosapp"),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks
          .instance
          .buildShortLink(dynamicLinkParameters);
      url = shortDynamicLink.shortUrl;
    } else {
      url =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParameters);
    }
    linkMessage = url.toString();
    return linkMessage;
  }

  static Future<void> initDynamicLink() async {
    Stream<PendingDynamicLinkData> onLink =
        FirebaseDynamicLinks.instance.onLink;
    onLink.forEach((dynamicLink) async {
      final Uri deepLink = dynamicLink.link;

      var isCode = deepLink.pathSegments.contains('survey');
      if (isCode) {
        String code = deepLink.queryParameters['code']!;
        try {
          SurveyService surveyService = SurveyService();
          Survey? survey = await surveyService.getSurveyByCode(code);
          if (survey != null) {
            Get.offNamed("/answer", arguments: survey);
          } else {
            print('no codeeee-----------------');
          }
        } catch (e) {
          print(e);
        }
      }
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      final Uri deepLink = data.link;
      String code = deepLink.queryParameters['code']!;
      try {
        SurveyService surveyService = SurveyService();
        Survey? survey = await surveyService.getSurveyByCode(code);
        if (survey != null) {
          Get.offNamed("/answer", arguments: survey);
        } else {
          print('no codeeee-----------------');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
