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
  int? sliderValue;
  int? sliderMin;
  int? sliderMax;

  PromptModel({
    required this.text,
    required this.type,
    this.fontStyle,
    this.answer,
    this.yesSelected,
    this.noSelected,
    this.controller,
    this.multipleChoiceOptions,
    this.sliderValue,
    this.sliderMin = 0,
    this.sliderMax = 100,
  }) {
    sliderValue ??= sliderMin;
    answer = sliderValue.toString();
  }
}

enum PromptType { info, yesno, textbox, number, multipleChoice, slider }
