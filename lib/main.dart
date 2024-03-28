import 'package:flutter/material.dart';

void main() {
  runApp(KNote());
}

class KNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _l = [];
  List<FocusNode> _lf = [];

  @override
  void initState() {
    super.initState();
    // Initialize _lf with a FocusNode for each text field in _l
    _lf = List.generate(_l.length, (index) => FocusNode());
  }


  @override
  void dispose() {
    for (var node in _lf) {
      node.dispose();
    }
    super.dispose();
  }

  void _addNote() {
    setState(() {
      _lf.add(FocusNode());
      _l.add('');
      _lf[_lf.length-1].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KNote'),
      ),
      body: ListView.builder(
        itemCount: _l.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: TextField(
              focusNode: _lf[index], // Associate the focus node with the text field
              onChanged: (value) {
                // Update the corresponding string in _l when the text changes
                setState(() {
                  _l[index] = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Note',
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }
}
