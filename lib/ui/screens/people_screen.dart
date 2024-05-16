import 'package:flutter/material.dart';
import 'package:knote/models/database.dart';
import '../../models/balance_sheet.dart';
import '../../models/transaction_result.dart';

class KNotePeopleScreen extends StatefulWidget {
  final KNoteDataBase db;
  final BalanceSheet balanceSheet;

  const KNotePeopleScreen(
      {super.key, required this.db, required this.balanceSheet});

  @override
  KNotePeopleScreenState createState() => KNotePeopleScreenState();
}

class KNotePeopleScreenState extends State<KNotePeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: _onBackButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('People'),
        ),
        body: ListView(
          children: [
            for (int i = 0; i < widget.balanceSheet.results.length; ++i)
              Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  // Check if there's more than 1 item
                  if (widget.balanceSheet.results.length > 1) {
                    // If there's more than 1 item, allow dismissal
                    return true;
                  } else {
                    // If there's only 1 item, prevent dismissal and show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cannot remove the last person."),
                        duration:
                            Duration(seconds: 1), // Adjust duration as needed
                      ),
                    );
                    return false;
                  }
                },
                onDismissed: (direction) {
                  setState(() {
                    widget.balanceSheet.removePerson(i);
                  });
                  widget.db.update();
                },
                child: Container(
                  color: i % 2 == 1 ? Colors.green[50] : Colors.green[100],
                  child: ListTile(
                    onTap: () {
                      _editPerson(context, i);
                    },
                    title: Text(widget.balanceSheet.results[i].person),
                    // debugging code to check sizes
                    // title: Text(
                    //   '${widget.balanceSheet?.results[i][0]} (${widget.balanceSheet?.results[i].length})'
                    // ),
                    subtitle: null,
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                _addPerson(context);
              },
              tooltip: 'Add Person',
              child: const Icon(Icons.add),
            ),
            // SizedBox(width: 16), // Add some spacing between the buttons
            // FloatingActionButton(
            //   heroTag: null,
            //   onPressed: () {
            //     _addItem(context);
            //   },
            //   tooltip: 'Add Note',
            //   child: Icon(Icons.add),
            // ),
          ],
        ),
      ),
    );
  }

  void _addPerson(BuildContext context) {
    int n = widget.balanceSheet.results.length;

    widget.balanceSheet.addPerson();
    setState(() {});
    _editPerson(context, n);
  }

  Future<bool> _onBackButtonPressed(bool didPop) async {
    _save(); // Call _save when the back button is pressed
    return true; // Return true to allow the back navigation
  }

  void _save() {
    // setState(() {
    //   widget.balanceSheet?.title = _controller.text;
    // });
    widget.db.update();
  }

  void _editPerson(BuildContext context, int index) {
    TextEditingController controllerTitle =
        TextEditingController(text: widget.balanceSheet.results[index].person);
    FocusNode focusNodeTitle = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        controllerTitle.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTitle.text.length);
        return AlertDialog(
          title: const Text('Edit Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controllerTitle,
                decoration: const InputDecoration(labelText: 'Person Name'),
                focusNode: focusNodeTitle,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.balanceSheet.results[index].person =
                      controllerTitle.text;
                });
                widget.db.update();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    focusNodeTitle.requestFocus();
  }
}
