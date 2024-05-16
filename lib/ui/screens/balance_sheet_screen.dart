import 'package:flutter/material.dart';
import 'package:knote/models/database.dart';
import '../../models/balance_sheet.dart';
import '../../utils/utils.dart';

import 'people_screen.dart';
import 'transaction_screen.dart';
import '../../models/transaction.dart';

class KNoteBalanceSheetScreen extends StatefulWidget {
  final KNoteDataBase db;
  final BalanceSheet balanceSheet;

  const KNoteBalanceSheetScreen(
      {super.key, required this.db, required this.balanceSheet});

  @override
  KNoteBalanceSheetScreenState createState() => KNoteBalanceSheetScreenState();
}

class KNoteBalanceSheetScreenState extends State<KNoteBalanceSheetScreen> {
  late TextEditingController _controller;
  final _titleFocus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.balanceSheet.title);
    _titleFocus.requestFocus();
    _titleFocus.addListener(_selectAllTitle);
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
                focusNode: _titleFocus,
                decoration: const InputDecoration(labelText: 'Title'),
                onEditingComplete: _save,
              ),
              // const SizedBox(height: 10),z // Add some space between text fields
              Container(
                color: Colors.green[50],
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "People",
                    border: InputBorder.none, // Remove default border
                  ),
                  controller: TextEditingController(
                    text: widget.balanceSheet.results
                        .map((i) => i.person)
                        .join(', '),
                  ),
                  onTap: () => _editPeople(context),
                ),
              ),
              const SizedBox(height: 10), // Add some space between text fields
              Expanded(
                child: ListView(
                  children: [
                    for (int i = widget.balanceSheet.log.length - 1;
                        i >= 0;
                        --i)
                      Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            // TODO
                            // update results
                            widget.balanceSheet.log.removeAt(i);
                          });
                          widget.db.update();
                        },
                        child: Container(
                          color: i % 2 == 1 ? Colors.white : Colors.grey[200],
                          child: ListTile(
                            onTap: () {
                              _editTransaction(context, i);
                            },
                            title: Text(widget.balanceSheet.log[i].title),
                            subtitle: null,
                            trailing: SizedBox(
                              width: 100,
                              child: TextField(
                                controller: TextEditingController(
                                    text: cents2str(
                                        widget.balanceSheet.log[i].amount,
                                        false)),
                                readOnly: true,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Amount',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // const SizedBox(width: 16), // Add some spacing between the buttons
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                _addTransaction(context);
              },
              tooltip: 'Add Transaction',
              child:
                  const Icon(Icons.add), // Icon representing a group of people
            ),
          ],
        ),
      ),
    );
  }

  void _selectAllTitle() {
    if (_titleFocus.hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  void _addTransaction(BuildContext context) {
    int n = widget.balanceSheet.log.length;
    int np = widget.balanceSheet.results.length;

    widget.balanceSheet.log.add(Transaction.defaults(n, np));
    _editTransaction(context, n);
  }

  void _editTransaction(BuildContext context, int index) {
    // Navigate to a new screen
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          builder: (context) => KNoteTransactionScreen(
              db: widget.db,
              balanceSheet: widget.balanceSheet,
              transaction: widget.balanceSheet.log[index])),
    )
        .then((_) {
      setState(() {});
      widget.db.update();
    });
  }

  Future<bool> _onBackButtonPressed(bool didPop) async {
    _save(); // Call _save when the back button is pressed
    return true; // Return true to allow the back navigation
  }

  void _save() {
    setState(() {
      widget.balanceSheet.title = _controller.text;
    });
    widget.db.update();
  }

  void _editPeople(BuildContext context) {
    // Navigate to a new screen
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          builder: (context) => KNotePeopleScreen(
              db: widget.db, balanceSheet: widget.balanceSheet)),
    )
        .then((_) {
      setState(() {});
      widget.db.update();
    });
  }
}
