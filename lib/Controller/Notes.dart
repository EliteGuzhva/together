import 'package:flutter/material.dart';
import 'package:together/Model/Note.dart';
import 'package:together/Core/UIFunctions.dart';
import 'package:together/Controller/EditNote.dart';
import 'package:together/View/NoteCard.dart';
import 'package:together/View/WidgetToLoad.dart';
import 'package:together/ViewModel/NotesViewModel.dart';

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NotesViewModel _viewModel = NotesViewModel();

  double _padding = 15.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("All notes"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.note_add),
              onPressed: () => _goToEditing(Note.createNew()))
        ],
      ),
      body: StreamBuilder(
        stream: _viewModel.notesStream,
        builder: (context, snapshot) {
          _viewModel.loadData(snapshot);

          return buildList();
        },
      ),
    );
  }

  Widget buildList() {
    return WidgetToLoad(
        viewModel: _viewModel,
        child: ListView.builder(
            padding: EdgeInsets.only(bottom: _padding),
            itemCount: _viewModel.notes.length,
            itemBuilder: (context, pos) {
              return GestureDetector(
                child: NoteCard(note: _viewModel.notes[pos]),
                onTap: () => _goToEditing(_viewModel.notes[pos]),
              );
            })
    );
  }

  void _goToEditing(Note noteToEdit) {
    pushPage(context, EditNote(note: noteToEdit));
  }
}
