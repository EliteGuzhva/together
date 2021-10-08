import 'package:flutter/material.dart';
import 'package:together/Core/UIFunctions.dart';
import 'package:together/Model/Note.dart';
import 'package:together/ViewModel/EditNoteViewModel.dart';

class EditNote extends StatefulWidget {
  EditNote({Key key, this.note}) : super(key: key);

  final Note note;

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  EditNoteViewModel _viewModel;

  double _padding = 15.0;

  List<Color> _availableColors = [
    Color(0xFFFF7777),
    Color(0xFFCCEEFF),
    Color(0xFFCCFFEE),
    Color(0xFFFFFF88),
    Color(0xFFAAAAAA)
  ];

  List<Widget> _colorSelection = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _viewModel = EditNoteViewModel(note: widget.note);
    _titleController.text = widget.note.title;
    _bodyController.text = widget.note.text;

    for (int i = 0; i < _availableColors.length; i++) {
      Widget button = FloatingActionButton(
        mini: true,
        heroTag: i,
        backgroundColor: _availableColors[i],
        onPressed: () {
          _viewModel.color = _availableColors[i];
        },
      );
      _colorSelection.add(button);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _viewModel.onWillPop,
      child: StreamBuilder(
          stream: _viewModel.colorStream,
          initialData: Color(_viewModel.note.color),
          builder: (context, snapshot) {
            Color currentColor = snapshot.data;

            return Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: Builder(builder: (context) {
                      return AppBar(
                        backgroundColor:
                            Color(currentColor.value - 0x00222222),
                        title: TextField(
                          controller: _titleController,
                          onChanged: _viewModel.titleChanged,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
