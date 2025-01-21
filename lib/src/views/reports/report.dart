import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

Color tapColour = const Color(0xFF277DFF);

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Monthly Statistics',
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(DateTime.utc(DateTime.now().month, DateTime.now().year)
                    .toString()),
                Transform.rotate(
                    angle: 180 * math.pi / 360,
                    child: const Icon(
                      Icons.chevron_right,
                    ))
              ],
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: Text(.toString()),
          // ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Scores(colour: Colors.green, text: 'Gait:'),
                  // Spacer(),
                  Scores(colour: Colors.grey, text: 'Balance:'),
                  // Spacer(),
                  Scores(colour: Colors.amber, text: 'Therapy:'),
                ],
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name:"),
                        SizedBox(height: 8),
                        Text("Age"),
                        SizedBox(height: 8),
                        Text("Gender:"),
                        SizedBox(height: 8),
                        Text("Indication:"),
                      ],
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name:"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Age"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Gender:"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Indication:"),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              SmallTapBlock(),
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 24, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Findings",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child:  Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "History",
                    //         style: TextStyle(fontWeight: FontWeight.bold, color: tapColour),
                    //       ),
                    //       Icon(Icons.chevron_right, color: tapColour,)
                    //     ],
                    //   ),
                    // ),
                    LargeTapBlock(),
                    Divider(),
                    LargeTapBlock(),
                    Divider(),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [Text("History"), Icon(Icons.chevron_right)],
                    //   ),
                    // ),
                    LargeTapBlock(),
                    Divider(),
                    SizedBox(height: 16),
                    TwoWordRow(),
                    SizedBox(height: 16),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(flex: 7, child: Text("History")),
                    //     Expanded(flex: 2, child: Text("data"))
                    //   ],
                    // ),
                    TwoWordRow(),
                    SizedBox(height: 16),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(flex: 7, child: Text("History")),
                    //     Expanded(flex: 2, child: Text("data"))
                    //   ],
                    // ),
                    TwoWordRow(),
                    SizedBox(height: 16),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(flex: 7, child: Text("History")),
                    //     Expanded(flex: 2, child: Text("data"))
                    //   ],
                    // ),
                    TwoWordRow(),
                  ],
                ),
              ),
              Divider(),
              // GestureDetector(
              //   onTap: () {},
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [Text("History"), Icon(Icons.chevron_right)],
              //   ),
              // ),
              SmallTapBlock(),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallTapBlock extends StatelessWidget {
  const SmallTapBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      // child: Padding(
      //   padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "History",
            style: TextStyle(fontWeight: FontWeight.bold, color: tapColour),
          ),
          Icon(Icons.chevron_right, color: tapColour),
        ],
      ),
      // ),
    );
  }
}

class LargeTapBlock extends StatelessWidget {
  const LargeTapBlock({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 9,
            child: Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.bold, color: tapColour),
            ),
          ),
          Expanded(
              flex: 3,
              child: Text(
                "data",
                style: TextStyle(fontWeight: FontWeight.bold, color: tapColour),
              )),
          Icon(
            Icons.chevron_right,
            color: tapColour,
          )
        ],
      ),
    );
  }
}

class TwoWordRow extends StatelessWidget {
  const TwoWordRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 7, child: Text("History")),
        Expanded(flex: 3, child: Text("data"))
      ],
    );
  }
}

class Scores extends StatelessWidget {
  const Scores({super.key, required this.colour, required this.text});

  final Color colour;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: colour,
          size: 12,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const Text(
          "16",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
