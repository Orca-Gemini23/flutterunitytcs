import 'package:flutter/material.dart';
import 'package:walk/constants.dart';

Drawer navigationDrawer() {
  return Drawer(
    backgroundColor: Color(DRAWERCOLOR),
    semanticLabel: "drawer",
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
    elevation: 30,
    child: ListView.separated(
        itemBuilder: (context, index) {
          return drawerItem();
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 5,
            color: Color(BGCOLOR),
          );
        },
        itemCount: 3),
  );
}

Widget drawerItem() {
  return Container(
      // padding: EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: const Text(
          "Hello Testing",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        onPressed: () {},
      ));
}
