import 'package:flutter/material.dart';
import 'prompt_model.dart';

class PromptView extends StatefulWidget {
  final List<PromptModel> prompts;
  final Color backgroundColor;

  const PromptView({
    Key? key,
    required this.prompts,
    this.backgroundColor = Colors.deepOrange,
  }) : super(key: key);

  @override
  _PromptViewState createState() => _PromptViewState();
}

class _PromptViewState extends State<PromptView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _currentPromptIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _currentPromptIndex = 0;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPrompt() {
    if (_validateInput()) {
      if (_currentPromptIndex < widget.prompts.length - 1) {
        _controller.reset();
        _controller.forward();
        setState(() {
          _currentPromptIndex++;
          if (widget.prompts[_currentPromptIndex].type == PromptType.textbox ||
              widget.prompts[_currentPromptIndex].type == PromptType.number) {
            widget.prompts[_currentPromptIndex].controller?.clear();
          }
        });
      } else {
        print('All prompts finished!');
        for (var prompt in widget.prompts) {
          if (prompt.type != PromptType.info) {
            print('${prompt.text}: ${prompt.answer}');
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide valid input for the current prompt.')),
      );
    }
  }

  void _previousPrompt() {
    if (_currentPromptIndex > 0) {
      setState(() {
        _currentPromptIndex--;
      });
    }
  }

  bool _validateInput() {
    final currentPrompt = widget.prompts[_currentPromptIndex];

    if (currentPrompt.type == PromptType.info) {
      return true;
    }

    switch (currentPrompt.type) {
      case PromptType.yesno:
        return currentPrompt.yesSelected != null || currentPrompt.noSelected != null;
      case PromptType.textbox:
        return currentPrompt.answer != null &&
            currentPrompt.answer!.trim().isNotEmpty &&
            RegExp(r'^[a-zA-Z\s]+$').hasMatch(currentPrompt.answer!);
      case PromptType.number:
        return _isNumeric(currentPrompt.answer);
      case PromptType.multipleChoice:
        return currentPrompt.answer != null &&
            currentPrompt.multipleChoiceOptions!.contains(currentPrompt.answer);
      case PromptType.slider:
        return currentPrompt.sliderValue != null;
      default:
        return false;
    }
  }

  bool _isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Widget _buildPromptUI(PromptModel prompt) {
    TextStyle promptTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    if (prompt.fontStyle != null) {
      promptTextStyle = promptTextStyle.merge(prompt.fontStyle);
    }

    return Column(
      children: [
        Text(
          prompt.text,
          style: promptTextStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildInputUI(prompt),
      ],
    );
  }

  Widget _buildInputUI(PromptModel prompt) {
    switch (prompt.type) {
      case PromptType.yesno:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  prompt.answer = 'Yes';
                  prompt.yesSelected = true;
                  prompt.noSelected = false;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (prompt.yesSelected == true) {
                    return Colors.green;
                  }
                  return null;
                }),
              ),
              child: const Text('Yes'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  prompt.answer = 'No';
                  prompt.yesSelected = false;
                  prompt.noSelected = true;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                  if (prompt.noSelected == true) {
                    return Colors.green;
                  }
                  return null;
                }),
              ),
              child: const Text('No'),
            ),
          ],
        );
      case PromptType.textbox:
        return Center(
          child: Container(
            width: 300,
            child: TextField(
              controller: prompt.controller,
              onChanged: (value) {
                setState(() {
                  prompt.answer = value;
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        );
      case PromptType.number:
        return Center(
          child: Container(
            width: 300,
            child: TextField(
              controller: prompt.controller,
              onChanged: (value) {
                setState(() {
                  prompt.answer = value;
                });
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        );
      case PromptType.multipleChoice:
        List<Widget> buttons = [];
        int columnCount = 2;
        List<String> options = prompt.multipleChoiceOptions!;

        for (int i = 0; i < options.length; i += columnCount) {
          List<Widget> rowButtons = [];
          for (int j = i; j < i + columnCount && j < options.length; j++) {
            rowButtons.add(
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        prompt.answer = options[j];
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                        if (prompt.answer == options[j]) {
                          return Colors.green;
                        }
                        return null;
                      }),
                    ),
                    child: Text(options[j]),
                  ),
                ),
              ),
            );
          }
          buttons.add(Row(children: rowButtons));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons,
        );
      case PromptType.slider:
        return Column(
          children: [
            Slider(
              value: (prompt.sliderValue ?? prompt.sliderMin ?? 0).toDouble(),
              min: (prompt.sliderMin ?? 0).toDouble(),
              max: (prompt.sliderMax ?? 100).toDouble(),
              onChanged: (value) {
                setState(() {
                  prompt.sliderValue = value.round();
                  prompt.answer = prompt.sliderValue.toString();
                });
              },
            ),
            Text(
              prompt.answer ?? prompt.sliderValue.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            if (_currentPromptIndex == widget.prompts.length - 1 &&
                prompt.sliderValue == prompt.sliderMin)
              const Text(
                'Please adjust the slider value',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        );
        default:
          return const SizedBox();
      }
  }

  @override
  Widget build(BuildContext context) {
    final currentPrompt = widget.prompts[_currentPromptIndex];

    return Scaffold(
      appBar: AppBar(
        title: null,
        centerTitle: true,
        leading: _currentPromptIndex > 0
            ? IconButton(
                onPressed: _previousPrompt,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
      ),
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildPromptUI(currentPrompt),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextPrompt,
                child: Text(_currentPromptIndex == widget.prompts.length - 1
                    ? 'Finish'
                    : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
