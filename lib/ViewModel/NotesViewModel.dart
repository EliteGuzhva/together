import 'dart:async';

import 'package:together/Core/SnapshotLoader.dart';
import 'package:together/Model/Note.dart';
import 'package:together/Server/Server.dart';
import 'package:flutter/material.dart';

class NotesViewModel extends SnapshotLoader {
  List<Note> _notes = [];

  Stream<List<Note>> _notesStream = Server.instance.database.getNotesStream();
  Stream<List<Note>> get notesStream => _notesStream;

  @override
  void onDidLoad(AsyncSnapshot snapshot) {
    _notes = snapshot.data;
  }

  List<Note> get notes => _notes;
}