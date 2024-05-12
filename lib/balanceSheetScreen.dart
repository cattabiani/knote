import 'package:flutter/material.dart';
import 'package:knote/database.dart';
import 'balanceSheet.dart';

import 'peopleScreen.dart';

class KNoteBalanceSheetScreen extends StatefulWidget {
  KNoteDataBase db;
  final int index;
  BalanceSheet? balanceSheet;
  

  KNoteBalanceSheetScreen({required this.db, required, required this.index}) {
    balanceSheet = db.items[index]!;
  }

  @override
  _KNoteBalanceSheetScreenState createState() => _KNoteBalanceSheetScreenState();
}

class _KNoteBalanceSheetScreenState extends State<KNoteBalanceSheetScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.balanceSheet?.title);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: _onBackButtonPressed,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Edit Balance Sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Title'),
              onEditingComplete: _save,
            ),
            const SizedBox(height: 10), // Add some space between text fields
            Container(
              color: Colors.grey[200],
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "People",
                  border: InputBorder.none, // Remove default border
                ),
                controller: TextEditingController(
                  text: widget.balanceSheet?.results.map((i) => i[0]).join(', '),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              _editPeople(context, widget.db, widget.index);
            },
            tooltip: 'Edit People',
            child: Icon(Icons.group), // Icon representing a group of people
          ),    
          // SizedBox(width: 16), // Add some spacing between the buttons
        ],
      ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(bool didPop) async {
    _save(); // Call _save when the back button is pressed
    return true; // Return true to allow the back navigation
  }

  void _save() {
    setState(() {
      widget.balanceSheet?.title = _controller.text;
    });
    widget.db.update();
  }

  void _editPeople(BuildContext context, KNoteDataBase db, int index) {
    // Navigate to a new screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => KNotePeopleScreen(db: db, index: index)),
    ).then((_) {
      setState(() {});
    });
  }
}


