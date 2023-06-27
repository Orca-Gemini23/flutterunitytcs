import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_strings.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Future<void> downloadJson() async {
    //return the file
  }

  Future<void> myMethod() async {
    //read the jsonfile here as string
    //save it in a string then convert it back to json object
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.quizTitle),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: FutureBuilder(
          builder: ((context, snapshot) {
            return Stack(
              children: const [
                Center(
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator()),
                ),
                Center(
                  child: Text('Comning soon!'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
