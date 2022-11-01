import 'package:chamitosapp/models/survey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswersSurveyScreen extends StatelessWidget {
  const AnswersSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List surveyInfo = Get.arguments;
    List<String> answersUsers = surveyInfo[1];
    Survey survey = surveyInfo[0];
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Respuestas de la encuesta'),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(children: [
              Text('Nombre de la encuesta:${survey.name}'),
              const SizedBox(
                height: 8,
              ),
              Text('Descripcion de la encuesta: ${survey.description}'),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: answersUsers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Respuesta de persona NO. ${index + 1}'),
                        subtitle: Text(answersUsers[index]),
                      ),
                      const Divider()
                    ],
                  );
                },
              )
            ])));
  }
}
