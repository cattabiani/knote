import 'package:flutter/material.dart';
import 'package:knote/database.dart';
import 'balanceSheet.dart';


class KNotePeopleScreen extends StatefulWidget {
  KNoteDataBase db;
  final int index;
  BalanceSheet? balanceSheet;
  

  KNotePeopleScreen({required this.db, required, required this.index}) {
    balanceSheet = db.items[index]!;
  }

  @override
  _KNotePeopleScreenState createState() => _KNotePeopleScreenState();
}

class _KNotePeopleScreenState extends State<KNotePeopleScreen> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: _onBackButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('People'),
        ),
        body: ListView(
          children: [
            for (int i = 0; i < (widget.balanceSheet?.results.length ?? 0); ++i)
              Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  setState(() {
                    for (int j = i + 1; j < (widget.balanceSheet?.results.length ?? 0); ++j) {
                      widget.balanceSheet?.results[j].removeAt(i+1);
                    }
                    widget.balanceSheet?.results.removeAt(i);
                  });
                  widget.db.update();
                },
                child: Container(
                  color: i % 2 == 1 ? Colors.white : Colors.grey[200],
                  child: ListTile(
                    onTap: () {
                      _editPerson(context, i);
                    },
                    title: Text(widget.balanceSheet?.results[i][0]),
                    // debugging code to check sizes
                    // title: Text(
                    //   '${widget.balanceSheet?.results[i][0]} (${widget.balanceSheet?.results[i].length})'
                    // ),
                    subtitle:  null,
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
              child: Icon(Icons.add),
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
    int n = (widget.balanceSheet?.results.length ?? 0);

    List<int> zeros = List<int>.filled(n, 0);
    widget.balanceSheet?.results.add(['Person $n', ...zeros]);
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
        TextEditingController(text: widget.balanceSheet?.results[index][0]);
    FocusNode focusNodeTitle = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        controllerTitle.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTitle.text.length);
        return AlertDialog(
          title: Text('Edit Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controllerTitle,
                decoration: InputDecoration(labelText: 'Person Name'),
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
                  widget.balanceSheet?.results[index][0] = controllerTitle.text;
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
