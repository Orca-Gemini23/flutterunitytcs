import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
        title: Text("Lifespark Quiz"),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: FutureBuilder(
          builder: ((context, snapshot) {
            return const CircularProgressIndicator();
          }),
        ),
      ),
    );
  }
}
