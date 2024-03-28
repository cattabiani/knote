// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<String> _notes = [];

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('KNotes'),
//     ),
//     body: ListView.builder(
//       itemCount: _notes.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           tileColor: index.isEven ?  Colors.blue[200] : Colors.white,
//           title: TextField(
//             initialValue: _notes[index],
//             onChanged: (newValue) {
//               setState(() {
//                 _notes[index] = newValue;
//               });
//             },

//           ),
//         );
//       },
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         setState(() {
//           _notes.add('Note ${_notes.length + 1}');
//         });
        
//       },
//       tooltip: 'Add Note',
//       child: Icon(Icons.add),
//     ),
//   );
// }


// }


// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: ListView.builder(
//         itemCount: _notes.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             tileColor: index.isEven ? Colors.white : Colors.grey[200], // Alternate colors
//             title: InkWell(
              
//               child: _buildNoteTextField(index),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addNote();
//         },
//         tooltip: 'Add Note',
//         child: Icon(Icons.add),
//       ),
//     );

//   Widget _buildNoteTextField(int index) {
//     _currentNoteController?.dispose();
    
//     _currentNoteController = TextEditingController(text: _notes[index]);

//     return TextField(
//       controller: _currentNoteController,
//       decoration: InputDecoration(
//         border: InputBorder.none, // Remove the border
//         hintText: 'Enter note', // Placeholder text
//       ),
//       onChanged: (value) {
//         _notes[index] = value;
//       },
//     );
//   }

//   void _addNote() {
//     setState(() {
//       // Add a new note to the list
//       _notes.add('');
//       _buildNoteTextField(_notes.length-1);
//     });

    

//   }
// }
