import 'package:chamitosapp/controllers/survey_controller.dart';
import 'package:chamitosapp/ui/input_decorations.dart';
import 'package:chamitosapp/widgets/custom_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswerSurveyScreen extends StatelessWidget {
  const AnswerSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyController = Get.put(SurveyController());
    surveyController.survey = Get.arguments;
    List<TextEditingController> textEditingController = [];
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.indigo,
            title: const Text('Responder encuesta')),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Text('Nombre de la encuesta:${surveyController.survey.name}'),
              const SizedBox(
                height: 8,
              ),
              Text(
                  'Descripcion de la encuesta: ${surveyController.survey.description}'),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: surveyController.survey.questions.length,
                itemBuilder: (context, index) {
                  textEditingController.add(TextEditingController());
                  return Form(
                      key: UniqueKey(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: textEditingController[index],
                            onChanged: (value) async {
                              if (surveyController
                                      .survey.questions[index].answers.length ==
                                  0) {
                                surveyController.survey.questions[index].answers
                                    .add('');
                              }

                              if (surveyController
                                      .survey.questions[index].fieldType ==
                                  'Fecha') {
                                DateTime date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime.now()) ??
                                    DateTime(2022);
                                textEditingController[index].text =
                                    '${date.day}/${date.month}/${date.year}';
                              } else {
                                surveyController.survey.questions[index]
                                    .answers[surveyController.survey
                                        .questions[index].answers.length -
                                    1] = value;
                              }
                            },
                            keyboardType: getType(surveyController
                                .survey.questions[index].fieldType),
                            decoration: InputDecorations.authInputDecoration(
                                hintText: '',
                                labelText: surveyController
                                    .survey.questions[index].question,
                                prefixIcon: Icons.question_mark_outlined),
                            validator: (value) {
                              return surveyController
                                          .survey.questions[index].isRequired &&
                                      value != null &&
                                      value.isEmpty
                                  ? 'Campo Requerido'
                                  : null;
                            },
                          ),
                          const Divider()
                        ],
                      ));
                },
              ),
              CustomMaterialButton(
                  onPressed: () async {
                    // SurveyService surveyService = SurveyService();
                    // await surveyService
                    //     .saveSurveyByCode(surveyController.survey.code);
                    await Get.defaultDialog(
                        title: "Se han enviado las respuestas",
                        middleText: 'Gracias por participar',
                        confirm: CustomMaterialButton(
                            onPressed: () {
                              Get.back();
                            },
                            text: 'Ok'));
                    Get.offNamed("/login");
                  },
                  text: 'Enviar respuestas')
            ],
          ),
        ));
  }

  TextInputType getType(String fieldType) {
    switch (fieldType) {
      case "Texto":
        return TextInputType.text;

      case "Fecha":
        return TextInputType.datetime;

      case "Número":
        return TextInputType.number;

      default:
        return TextInputType.text;
    }
  }
}
