import 'package:flutter/material.dart';

class KStyles {
  static const stdPadding = 8.0;
  static const stdFontSize = 18.0;
  static final Color stdGrey = Colors.grey[50] ?? Colors.white;
  static final Color stdGreen = Colors.green[50] ?? Colors.white;

  static const EdgeInsets stdEdgeInset = EdgeInsets.all(8.0);
  static const SizedBox stdSizedBox = SizedBox(width: 10, height: 10);

  static const TextStyle stdTextStyle = TextStyle(
    fontSize: stdFontSize, // Set the desired font size
    color: Colors.black, // Set the default text color
    fontWeight: FontWeight.normal, // Set the default font weight
  );

  static const TextStyle boldTextStyle = TextStyle(
    fontSize: stdFontSize,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static Container stdBackgroundDelete = Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: stdEdgeInset,
    child: const Icon(Icons.delete, color: Colors.white),
  );

  static Color altGrey(int i) {
    if (i % 2 == 1) {
      return Colors.white;
    } else {
      return Colors.grey[200] ?? Colors.grey;
    }
  }

  static Color altGreen(int i) {
    if (i % 2 == 1) {
      return Colors.green[50] ?? Colors.white;
    } else {
      return Colors.green[100] ?? Colors.grey;
    }
  }
}
