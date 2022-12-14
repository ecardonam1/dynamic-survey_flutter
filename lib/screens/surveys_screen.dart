import 'package:chamitosapp/models/survey.dart';
import 'package:chamitosapp/services/services.dart';
import 'package:chamitosapp/widgets/custom_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SurveysScreen extends StatelessWidget {
  const SurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Survey> surveys = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mis Encuestas'),
      ),
      body: ListView.builder(
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                trailing: SizedBox(
                  width: 100,
                  child: Center(
                    child: Row(
                      children: [
                        IconButton(
                            color: Colors.indigoAccent,
                            onPressed: () {
                              SurveyService surveyService = SurveyService();

                              List<String> answersUsers =
                                  surveyService.getAnswersUsers(surveys[index]);
                              final List survey = [
                                surveys[index],
                                answersUsers
                              ];
                              Get.toNamed('answers', arguments: survey);
                            },
                            icon: const Icon(Icons.query_stats_rounded)),
                        IconButton(
                            color: Colors.indigoAccent,
                            onPressed: () async {
                              await Get.defaultDialog(
                                  title: 'Encuesta creada',
                                  confirm: CustomMaterialButton(
                                      onPressed: () {
                                        Share.share(
                                            '''Responde la encuesta con el C??digo: ${surveys[index].code}
                                  o el enlace:  ${surveys[index].link};''');
                                      },
                                      text: 'Share'),
                                  cancel: CustomMaterialButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      text: 'Ok'),
                                  middleText: '''
                            Comparte el enlace: ${surveys[index].link}
                            o 
                            C??digo: ${surveys[index].code}
                            para responder la encuesta''');
                            },
                            icon: const Icon(Icons.share_outlined))
                      ],
                    ),
                  ),
                ),
                title: Text(surveys[index].name),
                subtitle: Text(surveys[index].description),
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }
}
