import 'package:chamitosapp/models/survey.dart';
import 'package:chamitosapp/services/services.dart';
import 'package:chamitosapp/widgets/custom_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Get.offNamed("/login")),
        centerTitle: true,
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomMaterialButton(
              onPressed: () {
                Get.toNamed("/forms");
              },
              text: 'Crear nueva encuesta'),
          const SizedBox(
            height: 30,
          ),
          CustomMaterialButton(
              onPressed: () async {
                SurveyService surveyService = SurveyService();
                List<Survey> surveys = await surveyService.getSurveysByUser();
                Get.toNamed("/surveys", arguments: surveys);
              },
              text: 'Mis encuestas'),
          CustomMaterialButton(
              onPressed: () async {
                SurveyService surveyService = SurveyService();
                List<Survey> surveys = await surveyService.getSurveysByUser();
                Get.toNamed("/surveys", arguments: surveys);
              },
              text: 'Mis encuestas'),
          CustomMaterialButton(
              onPressed: () async {
                SurveyService surveyService = SurveyService();
                List<Survey> surveys = await surveyService.getSurveysByUser();
                onPressed: () => Get.offNamed("/login");
              },
              text: 'Cerrar Sesión'),
        ]),
      ),
    );
  }
}
