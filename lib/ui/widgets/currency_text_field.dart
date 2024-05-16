import 'package:flutter/material.dart';

class KNoteCurrencyTextField extends StatefulWidget {
  final int initIntValue;
  final Function(int) onValueChanged;

  const KNoteCurrencyTextField(
      {super.key, required this.initIntValue, required this.onValueChanged});

  @override
  KNoteCurrencyTextFieldState createState() => KNoteCurrencyTextFieldState();
}

class KNoteCurrencyTextFieldState extends State<KNoteCurrencyTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initIntValue == 0
            ? ''
            : '${widget.initIntValue ~/ 100}.${widget.initIntValue % 100}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Amount'),
      onChanged: (_) {
        widget.onValueChanged(getIntValue());
      },
    );
  }

  int getIntValue() {
    if (_controller.text.isEmpty) return 0;

    // Split the input by the decimal point
    final parts = _controller.text.split('.');

    // Extract the dollars and cents parts
    String dollars = parts[0];
    String cents = parts.length > 1 ? parts[1] : '';

    // If the cents part is empty or has only one digit, append a zero
    cents = cents.padRight(2, '0');

    // If the cents part has more than two digits, take only the first two
    if (cents.length > 2) {
      cents = cents.substring(0, 2);
    }

    // Combine dollars and cents with a decimal point
    final cleanedValue = '$dollars.$cents'.replaceAll(RegExp('[^0-9]'), '');

    // Parse the cleaned value as an integer
    return cleanedValue.isEmpty ? 0 : int.parse(cleanedValue);
  }

  // Update the text field with the cleaned and formatted input
  // void _updateTextField(String text) {
  //   _controller.value = _controller.value.copyWith(
  //     text: text,
  //     selection: TextSelection.collapsed(offset: text.length),
  //   );
  // }
}
