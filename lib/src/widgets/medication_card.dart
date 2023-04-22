import 'package:flutter/material.dart';
import 'package:walk/src/constants/app_color.dart';

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard(
      {super.key,
      required this.title,
      required this.doctor,
      this.onTap,
      required this.onDelete});

  final String title;

  final String doctor;
  final Function()? onTap;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColor.greenDarkColor, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 189, 189, 189),
            blurRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade400,
          ),
        ),
        title: Text(
          title,
          // style: const TextStyle(color: AppColor.whiteColor),
        ),
        subtitle: Text(
          'Prescribed by: $doctor',
          // style: const TextStyle(color: AppColor.greyLight),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          // color: AppColor.whiteColor,
        ),
        onTap: onTap,
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.title,
    required this.type,
    required this.amount,
    required this.afterFood,
    required this.onDelete,
  });

  final String title;
  final String type;
  final String amount;
  final int afterFood;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColor.greenDarkColor, width: 2.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 189, 189, 189),
            blurRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: Colors.red.shade400,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(type),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('amount: $amount'),
            Text('After food: ${afterFood == 0 ? 'No' : 'Yes'}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
