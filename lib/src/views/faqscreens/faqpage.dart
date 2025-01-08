import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/utils/global_variables.dart';

class Faqpage extends StatefulWidget {
  const Faqpage({super.key});

  @override
  State<Faqpage> createState() => _FaqpageState();
}

class _FaqpageState extends State<Faqpage> {
  int faqLength = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: AppColor.blackColor,
          size: DeviceSize.isTablet ? 36 : 24,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
        title: Text(
          "FAQ's",
          style: TextStyle(
            color: AppColor.blackColor,
            fontSize: DeviceSize.isTablet ? 38 : 19,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          // symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: DeviceSize.isTablet ? 28.h : 21.sp,
                  color: AppColor.greenDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 7,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomFAQWidget(
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 5,
                      thickness: DeviceSize.isTablet ? 3 : 1,
                      //DeviceType.tablet ? ,
                      color: AppColor.greyLight,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomFAQWidget extends StatefulWidget {
  CustomFAQWidget({super.key, required this.index});
  int index;

  @override
  State<CustomFAQWidget> createState() => _CustomFAQWidgetState();
}

class _CustomFAQWidgetState extends State<CustomFAQWidget> {
  List<String> questions = [
    "What is Parkinson’s Disease?",
    "Causes of Parkinson’s Disease ?",
    "Treatment for Parkinson’s Disease ?",
    "What is freezing of gait ?",
    "What is the device WALK ?",
    "Benefits of Sensory Cueing ?",
    "How does Walk help?",
  ];
  List<String> answers = [
    "Parkinson’s disease is a progressive disorder that affects the nervous system and the parts of the body controlled by the nerves causing tremors, stiffness and slowing of movement.",
    "Parkinson’s is caused by a loss of nerve cells in the part of the brain called the substantia nigra. Nerve cells in this part of the brain are responsible for producing a chemical called dopamine which helps control body movements. If these nerve cells die, the amount of dopamine in the brain is reduced causing movements to become slow and abnormal.",
    "Medication and physical therapy can help relieve the symptoms of Parkinson’s and maintain your quality life.",
    "Sudden, sort steps and temporary episodes of inability to move the feet forward despite the intention to walk.",
    "WALK is inspired by the concept of sensory cueing,a scientifically proven & rigorously tested therapy to alleviate gait disturbances in Parkinson’s. It is a non-invasive & easy to use wearable device that provides cueing at home & wherever you go.",
    "Sensory cueing entails stimulating the patient externally in a rhythmic manner. Rhythmic Auditory Cueing significantly improves mean gait velocity, cadence and stride length.",
    "WALK senses abnormal gait and produces cues to help align gait. It records trends in gait parameters and provides data driven personalized insights to improve therapy.",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (DeviceSize.isTablet) const SizedBox(height: 20),
        ExpansionTileTheme(
          data: const ExpansionTileThemeData(
              backgroundColor: Colors.transparent,
              collapsedTextColor: AppColor.blackColor,
              collapsedIconColor: AppColor.blackColor),
          child: ExpansionTile(
            title: Text(
              questions[widget.index],
              style: TextStyle(fontSize: 14.sp),
            ),
            tilePadding: EdgeInsets.zero,
            textColor: AppColor.blackColor,
            children: [
              Card(
                elevation: 0,
                color: AppColor.lightbluegrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    answers[widget.index],
                    style: TextStyle(fontSize: 14.sp),
                    // textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
        if (DeviceSize.isTablet) const SizedBox(height: 20),
      ],
    );
  }
}
