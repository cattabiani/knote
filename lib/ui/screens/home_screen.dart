import 'package:flutter/material.dart';
import 'package:knote/models/storage.dart';
import 'package:knote/models/item.dart';
import 'package:knote/utils/styles.dart';

class KHomeScreen extends StatefulWidget {
  final KStorage storage;

  const KHomeScreen({super.key, required this.storage});

  @override
  State<KHomeScreen> createState() => _KHomeScreenState();
}

class _KHomeScreenState extends State<KHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _editItem(int index) {
    final item = widget.storage.items[index];
    final TextEditingController nameController = TextEditingController(text: item.name);
    final TextEditingController infoController = TextEditingController(text: item.info);
    final nameFocus = FocusNode();


    showDialog(
      
      context: context,
      builder: (BuildContext context) {
        nameController.selection = TextSelection(
            baseOffset: 0, extentOffset: nameController.text.length);
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                focusNode: nameFocus,
                controller: nameController,
                style: KStyles.stdTextStyle,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: infoController,
                style: KStyles.stdTextStyle,
                decoration: const InputDecoration(labelText: 'Info'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  item.name = nameController.text;
                  item.info = infoController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_){
      nameController.dispose();
      infoController.dispose();
      nameFocus.dispose();
    });

    nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = widget.storage.items.removeAt(oldIndex);
              widget.storage.items.insert(newIndex, item);
            });
          },
          children: [
            for (int index = 0; index < widget.storage.items.length; index++)
              Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      widget.storage.items.removeAt(index);
                    });
                  },
                  background: KStyles.stdBackgroundDelete,
                  child: Container(
                      color: KStyles.altGrey(index),
                      child: Padding(
                          padding: KStyles.stdEdgeInset,
                          child: ListTile(
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                            onTap: () {
                              _editItem(index);
                            },
                            title: Text(widget.storage.items[index].name,
                                style: KStyles.stdTextStyle),
                            subtitle: widget.storage.items[index].info == ""
                                ? null
                                : Text(widget.storage.items[index].info,
                                    style: KStyles.stdTextStyle),
                          ))))
          ]),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          final n = widget.storage.items.length;
          setState(() {
            widget.storage.items
                .add(KItem.defaults("Item $n"));
          });
          _editItem(n);
          // Handle adding new items here
          // For example, you can navigate to a new screen to add items
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}



