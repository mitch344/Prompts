import 'package:flutter/material.dart';
import 'prompt_model.dart';
import 'prompt_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prompts = [
      PromptModel(
        text: 'Welcome To The Example!',
        type: PromptType.info,
        fontStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
      ),
      PromptModel(
        text: 'What is your favorite color?',
        type: PromptType.multipleChoice,
        multipleChoiceOptions: ['Red', 'Green', 'Blue', 'Yellow'],
      ),
      PromptModel(
        text: 'Are you a Developer?',
        type: PromptType.yesno,
        fontStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      PromptModel(
        text: 'What is your Name?',
        type: PromptType.textbox,
        controller: TextEditingController(),
        fontStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PromptModel(
        text: 'How many years?',
        type: PromptType.number,
        controller: TextEditingController(),
        fontStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      PromptModel(
        text: 'Great!',
        type: PromptType.info,
        fontStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
      ),
    ];
    return PromptView(prompts: prompts , backgroundColor: Colors.blueAccent);
  }
}
