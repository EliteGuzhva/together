import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:together/Core/UIFunctions.dart';
import 'package:together/Model/Note.dart';
import 'package:together/View/AppThemeData.dart';
import 'package:together/ViewModel/EditNoteViewModel.dart';

class EditNote extends StatefulWidget {
  EditNote({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  EditNoteViewModel _viewModel;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = EditNoteViewModel(note: widget.note);
    _titleController.text = widget.note.title;
    _bodyController.text = widget.note.text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeData>();
    final _padding = theme.padding;

    List<String> _availableColors = [
      "Red",
      "Green",
      "Yellow",
      "Cyan",
      "Black"
    ];

    List<Widget> _colorSelection = [];

    for (int i = 0; i < _availableColors.length; i++) {
      Color color = theme.colorPalette.getColorByName(_availableColors[i]);
      Widget button = FloatingActionButton(
        mini: true,
        heroTag: i,
        backgroundColor: color,
        onPressed: () {
          _viewModel.color = _availableColors[i];
        },
      );
      _colorSelection.add(button);
    }

    return WillPopScope(
      onWillPop: _viewModel.onWillPop,
      child: StreamBuilder(
          stream: _viewModel.colorStream,
          initialData: _viewModel.color,
          builder: (context, snapshot) {
            Color currentColor = theme.colorPalette.getColorByName(snapshot.data);

            return Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(55),
                    child: Builder(builder: (context) {
                      return AppBar(
                        backgroundColor:
                            Color(currentColor.value - 0x00222222),
                        title: TextField(
                          controller: _titleController,
                          onChanged: _viewModel.titleChanged,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: theme.colorPalette.foreground, fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () => _saveNote(context)),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteNote())
                        ],
                      );
                    })),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: currentColor,
                        child: Padding(
                          padding: EdgeInsets.all(_padding),
                          child: TextField(
                            controller: _bodyController,
                            onChanged: _viewModel.bodyChanged,
                            maxLines: 100,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Container(
                      margin: EdgeInsets.all(_padding / 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _colorSelection),
                    )
                  ],
                ));
          }),
    );
  }

  void _saveNote(BuildContext context) {
    _viewModel.saveNote().whenComplete(() {
      showSnack(context, "Заметка сохранилась!");
    });
  }

  void _deleteNote() {
    _viewModel.deleteNote().whenComplete(() {
      pop(context);
    });
  }
}
