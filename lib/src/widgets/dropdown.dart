import 'package:flutter/material.dart';
import 'package:walk/src/widgets/textfields.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];
  TextEditingController controller = TextEditingController();

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(
      () {
        if (isSelected) {
          if (itemValue == "other") {
            _selectedItems.add(itemValue);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      content: getLargeTextField(
                          "Please Write here", controller, Icons.ac_unit));
                });
          }
        } else {
          _selectedItems.remove(itemValue);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: widget.items
            .map(
              (item) => CheckboxListTile(
                value: _selectedItems.contains(item),
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (isChecked) {
                  _itemChange(item, isChecked!);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
