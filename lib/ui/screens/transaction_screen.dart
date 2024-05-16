import 'package:flutter/material.dart';
import 'package:knote/models/database.dart';
import '../../models/transaction.dart';
import '../../models/balance_sheet.dart';
import '../../utils/utils.dart';

class KNoteTransactionScreen extends StatefulWidget {
  final KNoteDataBase db;
  final BalanceSheet balanceSheet;
  final Transaction transaction;

  const KNoteTransactionScreen(
      {super.key,
      required this.db,
      required this.balanceSheet,
      required this.transaction});

  @override
  KNoteTransactionScreenState createState() => KNoteTransactionScreenState();
}

class KNoteTransactionScreenState extends State<KNoteTransactionScreen> {
  late TextEditingController _controller;
  late TextEditingController _amountController;
  final _titleFocus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.transaction.title);
    _amountController =
        TextEditingController(text: cents2str(widget.transaction.amount, true));
    _titleFocus.requestFocus();
    _titleFocus.addListener(_selectAllTitle);
  }

  void _selectAllTitle() {
    if (_titleFocus.hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: _onBackButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction'),
        ),
        body: ListView(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Title'),
              focusNode: _titleFocus,
              onEditingComplete: _save,
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: widget.transaction.creditor,
                hint: const Text('Select creditor'),
                items:
                    List.generate(widget.balanceSheet.results.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Container(
                        alignment: Alignment.center,
                        color: index % 2 == 0
                            ? Colors.green[50]
                            : Colors.green[100],
                        // padding: const EdgeInsets.symmetric(
                        //     vertical: 8.0, horizontal: 16.0),
                        child: Text(widget.balanceSheet.results[index].person)),
                  );
                }),
                onChanged: (int? newIndex) {
                  setState(() {
                    widget.transaction.creditor = newIndex ?? 0;
                  });
                },
                isExpanded: true,
              ),
            ),
            TextField(
              controller: _amountController,
              textAlign: TextAlign.center, // Align text to center
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
              onEditingComplete: _save,
            ),
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
      widget.transaction.title = _controller.text;
      widget.transaction.amount = str2cents(_amountController.text);
    });
    widget.db.update();
  }
}
