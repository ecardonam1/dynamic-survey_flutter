// To parse this JSON data, do
//
//     final surveys = surveysFromMap(jsonString);

import 'dart:convert';

class Survey {
  Survey(
      {this.key,
      required this.code,
      required this.description,
      required this.name,
      required this.questions,
      required this.user,
      required this.link});

  final String? key;
  final String link;
  final String code;
  final String description;
  final String name;
  final List<dynamic> questions;
  final String user;

  factory Survey.fromJson(String str) => Survey.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Survey.fromMap(Map<String, dynamic> json) => Survey(
        code: json["code"],
        description: json["description"],
        name: json["name"],
        questions: List<dynamic>.from(
            json["questions"].map((x) => Question.fromMap(x))),
        user: json["user"],
        link: json["link"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "description": description,
        "name": name,
        "questions": List<dynamic>.from(questions.map((x) => x.toMap())),
        "user": user,
      };

  Survey copyWith(
          {String? key,
          String? code,
          String? description,
          String? name,
          List? questions,
          String? user,
          String? link}) =>
      Survey(
          key: key ?? this.key,
          code: code ?? this.code,
          description: description ?? this.description,
          name: name ?? this.name,
          questions: questions ?? this.questions,
          user: user ?? this.user,
          link: link ?? this.link);
}

class Question {
  Question(
      {required this.fieldType,
      required this.question,
      required this.isRequired,
      required this.answers});

  final String fieldType;
  final String question;
  final bool isRequired;
  final List<dynamic> answers;

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        fieldType: json["fieldType"],
        question: json["question"],
        isRequired: json["isRequired"],
        answers: json["answers"] ?? [],
      );

  Map<String, dynamic> toMap() => {
        "fieldType": fieldType,
        "question": question,
        "isRequired": isRequired,
        "answers": answers,
      };
}
