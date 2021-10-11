import 'package:rxdart/rxdart.dart';
import 'package:together/Model/Note.dart';
import 'package:flutter/material.dart';
import 'package:together/Server/Server.dart';

class EditNoteViewModel {

  EditNoteViewModel({Key key, this.note}) {
    _titleStreamController.sink.add(note.title);
    _bodyStreamController.sink.add(note.text);
    _colorStreamController.sink.add(note.color);
  }

  Note note;

  Server _server = Server.getInstance();

  var _titleStreamController = BehaviorSubject<String>();
  var _bodyStreamController = BehaviorSubject<String>();
  var _colorStreamController = BehaviorSubject<String>();

  Function(String) get titleChanged => _titleStreamController.sink.add;
  Function(String) get bodyChanged => _bodyStreamController.sink.add;

  Stream<String> get colorStream => _colorStreamController.stream;

  String get color => _colorStreamController.stream.value;
  set color(String c) => _colorStreamController.sink.add(c);

  void _updateNote() {
    note = Note(
      _titleStreamController.stream.value,
      _bodyStreamController.stream.value,
      _colorStreamController.stream.value,
      DateTime.now(),
      note.id
    );
  }

  Future saveNote() async {
    _updateNote();
    await _server.database.updateNote(note);
  }

  Future deleteNote() async {
    _updateNote();
    await _server.database.deleteNote(note);
  }

  Future<bool> onWillPop() async {
    await saveNote();

    return true;
  }

  void dispose() {
    _titleStreamController.close();
    _bodyStreamController.close();
    _colorStreamController.close();
  }
}
