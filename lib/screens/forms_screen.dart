import 'package:chamitosapp/controllers/survey_controller.dart';
import 'package:chamitosapp/services/FirebaseDynamicLinkService.dart';
import 'package:chamitosapp/services/services.dart';
import 'package:chamitosapp/ui/input_decorations.dart';
import 'package:chamitosapp/widgets/custom_material_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyController = Get.put(SurveyController());
    RxBool tempNewQuestion = false.obs;
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.indigo,
            title: const Text('Creación de encuesta')),
        floatingActionButton: Obx(() {
          return FloatingActionButton(
              onPressed: () {
                tempNewQuestion.value = !tempNewQuestion.value;
              },
              child: (tempNewQuestion.value)
                  ? const Icon(Icons.keyboard_return_outlined)
                  : const Icon(Icons.add));
        }),
        body: Obx(() {
          if (!tempNewQuestion.value) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: surveyController.name.value,
                    onChanged: (value) {
                      surveyController.name.value = value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Ingrese el nombre de la encuesta',
                        labelText: 'Nombre de la encuesta:',
                        prefixIcon: Icons.query_stats),
                  ),
                  TextFormField(
                    initialValue: surveyController.description.value,
                    onChanged: (value) {
                      surveyController.description.value = value;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Ingrese la descripcion de la encuesta',
                        labelText: 'Descripcion de la encuesta:',
                        prefixIcon: Icons.details),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: surveyController.questions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Dismissible(
                            onDismissed: (direction) {
                              surveyController.removeQuestion(index);
                            },
                            background: Container(
                              color: Colors.green,
                              child: const Icon(Icons.check),
                            ),
                            key: UniqueKey(),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: const Icon(Icons.delete),
                            ),
                            child: TextFormField(
                              keyboardType: getType((surveyController
                                  .questions[index]['fieldType'])),
                              decoration: InputDecorations.authInputDecoration(
                                  hintText: '',
                                  labelText: surveyController.questions[index]
                                      ['question'],
                                  prefixIcon: Icons.question_mark_outlined),
                            ),
                          ),
                          const Divider()
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomMaterialButton(
                      onPressed: () async {
                        String code = UniqueKey().toString();
                        code = code.substring(2, code.length - 1);
                        String link =
                            await FirebaseDynamicLinkService.createDynamicLink(
                                true, code);
                        surveyController.addSurvey(code);
                        SurveyService surveyService = SurveyService();
                        await surveyService.createSurvey(
                            surveyController.survey.copyWith(link: link));

                        await Get.defaultDialog(
                            title: 'Encuesta creada',
                            confirm: CustomMaterialButton(
                                onPressed: () {
                                  Share.share(
                                      '''Responde la encuesta con el Código: $code 
                                  o el enlace: $link''');
                                },
                                text: 'Share'),
                            cancel: CustomMaterialButton(
                                onPressed: () {
                                  Get.back();
                                },
                                text: 'Ok'),
                            middleText: '''
                            Comparte el enlace: $link
                            o 
                            Código: $code
                            para responder la encuesta''');
                        Get.offNamed('home');
                      },
                      text: 'Crear encuesta')
                ],
              ),
            );
          }
          return addNew(surveyController, tempNewQuestion);
        }));
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

  Widget addNew(SurveyController surveyController, RxBool tempNewQuestion) {
    Map<dynamic, dynamic> tempQuestion =
        {'isRequired': false, 'question': '', 'fieldType': 'Texto'}.obs;
    return Obx(
      () {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  tempQuestion.update('question', (val) => value);
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'ingrese el título del campo',
                  labelText: 'Título del campo',
                )),
            CheckboxListTile(
                title: const Text("Campo requerido?"),
                value: tempQuestion['isRequired'],
                onChanged: (value) {
                  tempQuestion.update('isRequired', (val) => value!);
                }),
            Row(
              children: [
                const Text('Tipo de campo:'),
                const SizedBox(
                  width: 30,
                ),
                DropdownButton(
                  value: tempQuestion['fieldType'],
                  items: const [
                    DropdownMenuItem(
                      value: 'Texto',
                      child: Text('Texto'),
                    ),
                    DropdownMenuItem(
                      value: 'Número',
                      child: Text('Número'),
                    ),
                    DropdownMenuItem(
                      value: 'Fecha',
                      child: Text('Fecha'),
                    ),
                  ],
                  onChanged: (value) {
                    tempQuestion.update('fieldType', (val) => value.toString());
                  },
                )
              ],
            ),
            CustomMaterialButton(
                onPressed: () {
                  tempNewQuestion.value = false;
                  surveyController.addNewQuestion(tempQuestion);
                },
                text: 'Agregar')
          ],
        );
      },
    );
  }
}
