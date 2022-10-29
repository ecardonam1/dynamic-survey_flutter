import 'package:chamitosapp/models/survey.dart';
import 'package:get/get.dart';

class SurveyController extends GetxController {
  RxString name = ''.obs;
  RxString link = ''.obs;
  RxString description = ''.obs;
  List questions = [];
  RxList surveys = [].obs;
  late Survey survey;
  late List<Question> questionsModel = [];

  void addNewQuestion(dynamic question) {
    questions.add({
      'isRequired': question['isRequired'],
      'fieldType': question['fieldType'],
      'question': question['question']
    });

    questionsModel.add(
      Question(
          fieldType: question['fieldType'],
          question: question['question'],
          isRequired: question['isRequired'],
          answers: []),
    );
  }

  void removeQuestion(int index) {
    questions.removeAt(index);
  }

  void addSurvey(String code) {
    surveys.add({
      'code': code,
      'user': '',
      'name': name.value,
      'description': description.value,
      'questions': questions,
      'link': link.value
    });
    survey = Survey(
      code: surveys[surveys.length - 1]['code'],
      description: surveys[surveys.length - 1]['description'],
      name: surveys[surveys.length - 1]['name'],
      questions: questionsModel,
      user: surveys[surveys.length - 1]['user'],
      link: surveys[surveys.length - 1]['link'],
    );

    // questions.clear();
  }

  int numbersOfQuestions() {
    return questions.length;
  }
}
