import 'package:chamitosapp/models/survey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswersSurveyScreen extends StatelessWidget {
  const AnswersSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Survey survey = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Respuestas de la encuesta'),
      ),
      body: Container(),
    );
  }
}
