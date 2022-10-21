// To parse this JSON data, do
//
//     final surveys = surveysFromMap(jsonString);

import 'dart:convert';

class Survey {
  Survey({
    required this.code,
    required this.description,
    required this.name,
    required this.questions,
    required this.user,
  });

  final String code;
  final String description;
  final String name;
  final List<dynamic> questions;
  String user;

  factory Survey.fromJson(String str) => Survey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Survey.fromMap(Map<String, dynamic> json) => Survey(
        code: json["code"],
        description: json["description"],
        name: json["name"],
        questions: List<dynamic>.from(
            json["questions"].map((x) => Question.fromMap(x))),
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "description": description,
        "name": name,
        "questions": List<dynamic>.from(questions.map((x) => x.toMap())),
        "user": user,
      };
}

class Question {
  Question({
    required this.fieldType,
    required this.question,
    required this.isRequired,
  });

  final String fieldType;
  final String question;
  final bool isRequired;

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        fieldType: json["fieldType"],
        question: json["question"],
        isRequired: json["isRequired"],
      );

  Map<String, dynamic> toMap() => {
        "fieldType": fieldType,
        "question": question,
        "equired": isRequired,
      };
}
