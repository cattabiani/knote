import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'balanceSheet.dart';
// import 'editBalanceSheetScreen.dart';
import 'item.dart';
import 'database.dart';


class KNoteScreen extends StatefulWidget {
  @override
  _KNoteScreenState createState() => _KNoteScreenState();
}

class _KNoteScreenState extends State<KNoteScreen> {
  KNoteDataBase db = KNoteDataBase();

  @override
  void initState() {
    db.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KNote'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = db.items.removeAt(oldIndex);
            db.items.insert(newIndex, item);
          });
          db.update();
        },
        children: [
          for (int i = 0; i < db.items.length; ++i)
            Dismissible(
              key: ValueKey<String>(Uuid().v4()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                setState(() {
                  db.items.removeAt(i);
                });
                db.update();
              },
              child: Container(
                color: db.items[i] is Item
                  ? (i % 2 == 1 ? Colors.white : Colors.grey[200]) // Blue shades for balance sheet items
                  : (i % 2 == 1 ? Colors.blue[100] : Colors.blue[200]),  // Alternating colors
                child: ListTile(
                  onTap: () {
                    _editItem(context, i);
                  },
                  title: Text(db.items[i].title),
                  subtitle: db.items[i] is Item ? Text(db.items[i].info) : null,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      FloatingActionButton(
        onPressed: () {
          _addBalanceSheet(context);
        },
        tooltip: 'Open Balance Sheet',
        backgroundColor: Colors.green, // Change background color
        child: Icon(Icons.account_balance),
      ),
      SizedBox(width: 16), // Add some spacing between the buttons
      FloatingActionButton(
        onPressed: () {
          _addItem(context);
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    ],
  ),
    );
  }

  void _addItem(BuildContext context) {
    int n = db.items.length;
    db.items.add(Item('Item $n', ''));
    _editItem(context, n);
    db.update();
  }

  void _addBalanceSheet(BuildContext context) {
    int n = db.items.length;
    db.items.add(BalanceSheet('Balance Sheet $n'));
    setState(() {});
    db.update();
  }

  void _editItem(BuildContext context, int index) {
    TextEditingController controllerTitle =
        TextEditingController(text: db.items[index].title);
    TextEditingController controllerInfo =
        TextEditingController(text: db.items[index].info);
    FocusNode focusNodeTitle = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        controllerTitle.selection = TextSelection(
            baseOffset: 0, extentOffset: controllerTitle.text.length);
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: controllerTitle,
                decoration: InputDecoration(labelText: 'Title'),
                focusNode: focusNodeTitle,
              ),
              TextField(
                controller: controllerInfo,
                maxLines: null, // Allow multiple lines
                decoration: InputDecoration(labelText: 'Info'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  db.items[index].title = controllerTitle.text;
                  db.items[index].info = controllerInfo.text;
                });
                db.update();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    focusNodeTitle.requestFocus();
  }
}
