import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'balanceSheet.dart';
import 'balanceSheetScreen.dart';
import 'item.dart';
import 'database.dart';


class KNoteMainScreen extends StatefulWidget {
  KNoteDataBase db = KNoteDataBase();
  @override
  _KNoteMainScreenState createState() => _KNoteMainScreenState();
}

class _KNoteMainScreenState extends State<KNoteMainScreen> {
  

  @override
  void initState() {
    widget.db.load();

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
            final item = widget.db.items.removeAt(oldIndex);
            widget.db.items.insert(newIndex, item);
          });
          widget.db.update();
        },
        children: [
          for (int i = 0; i < widget.db.items.length; ++i)
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
                  widget.db.items.removeAt(i);
                });
                widget.db.update();
              },
              child: Container(
                color: widget.db.items[i] is Item
                  ? (i % 2 == 1 ? Colors.white : Colors.grey[200]) // Blue shades for balance sheet items
                  : (i % 2 == 1 ? Colors.green[100] : Colors.green[200]),  // Alternating colors
                child: ListTile(
                  onTap: () {
                    _editEntry(context, i);
                  },
                  title: Text(widget.db.items[i].title),
                  subtitle: widget.db.items[i] is Item ? Text(widget.db.items[i].info) : null,
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
              _addBalanceSheet(context);
            },
            tooltip: 'Open Balance Sheet',
            backgroundColor: Colors.green, // Change background color
            child: Icon(Icons.account_balance),
          ),
          SizedBox(width: 16), // Add some spacing between the buttons
          FloatingActionButton(
            heroTag: null, 
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
    int n = widget.db.items.length;
    widget.db.items.add(Item('Item $n', ''));
    setState(() {});
    _editItem(context, n);
  }

  void _addBalanceSheet(BuildContext context) {
    int n = widget.db.items.length;
    widget.db.items.add(BalanceSheet('Balance Sheet $n', [["self"]]));

    setState(() {});
    _editBalanceSheet(context, widget.db, n);
  }

  void _editEntry(BuildContext context, int index) {
    final item = widget.db.items[index];

    if (item is Item) {
      _editItem(context, index);
    } else if (item is BalanceSheet) {
      _editBalanceSheet(context, widget.db, index);
    }
  }

  void _editBalanceSheet(BuildContext context, KNoteDataBase db, int index) {
    // Navigate to a new screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => KNoteBalanceSheetScreen(db: db, index: index)),
    ).then((_) {
      setState(() {});
    });
  }


  void _editItem(BuildContext context, int index) {
    TextEditingController controllerTitle =
        TextEditingController(text: widget.db.items[index].title);
    TextEditingController controllerInfo =
        TextEditingController(text: widget.db.items[index].info);
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
                  widget.db.items[index].title = controllerTitle.text;
                  widget.db.items[index].info = controllerInfo.text;
                });
                widget.db.update();
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
