import 'package:flutter/material.dart';

class PromptModel {
  final String text;
  final PromptType type;
  final TextStyle? fontStyle;
  String? answer;
  bool? yesSelected;
  bool? noSelected;
  TextEditingController? controller;
  List<String>? multipleChoiceOptions;

  PromptModel({
    required this.text,
    required this.type,
    this.fontStyle,
    this.answer,
    this.yesSelected,
    this.noSelected,
    this.controller,
    this.multipleChoiceOptions,
  });
}

enum PromptType { info, yesno, textbox, number, multipleChoice }
