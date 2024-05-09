import 'package:flutter/material.dart';
import 'balanceSheet.dart';

class EditBalanceSheetScreen extends StatefulWidget {
  final BalanceSheet balanceSheet;

  EditBalanceSheetScreen({required this.balanceSheet});

  @override
  _EditBalanceSheetScreenState createState() => _EditBalanceSheetScreenState();
}

class _EditBalanceSheetScreenState extends State<EditBalanceSheetScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.balanceSheet.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Balance Sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Title'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void _saveChanges() {
    widget.balanceSheet.title = _controller.text;
  }
}
