import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox("box0");

  runApp(KNoteApp());
}

class KNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNote',
      home: KNoteScreen(),
    );
  }
}

class KNoteScreen extends StatefulWidget {
  @override
  _KNoteScreenState createState() => _KNoteScreenState();
}

class ItemsDataBase {
  List items = [];

  final _box = Hive.box("box0");

  void createInitialData() {
    items = [];
  }

  void loadData() {
    var temp = _box.get("items");
    if (temp == null) {
      // initial data
      items = [];
    }
    else {
      items = temp;
    }
  }

  void update() {
    _box.put("items", items);
  }
}

class _KNoteScreenState extends State<KNoteScreen> {

  ItemsDataBase db = ItemsDataBase();

  @override
  void initState() {
    db.loadData();

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
                color: i % 2 == 1 ? Colors.white : Colors.grey[200], // Alternating colors
                child: ListTile(
                  onTap: () {
                    _editItem(context, i);
                  },
                  title: Text(db.items[i][0]),
                  subtitle: Text(db.items[i][1]), 
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(context);
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem(BuildContext context) {
    int n = db.items.length;
    db.items.add(['Item $n','']);
    _editItem(context, db.items.length-1);
    db.update();
  }

  void _editItem(BuildContext context, int index) {
    TextEditingController controllerTitle = TextEditingController(text: db.items[index][0]);
    TextEditingController controllerInfo = TextEditingController(text: db.items[index][1]);
    FocusNode focusNodeTitle = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        controllerTitle.selection = TextSelection(baseOffset: 0, extentOffset: controllerTitle.text.length);
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
                setState(() {
                  db.items[index][0] = controllerTitle.text;
                  db.items[index][1] = controllerInfo.text;
                });
                db.update();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    focusNodeTitle.requestFocus();
  }


}