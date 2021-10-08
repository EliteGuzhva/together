import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:together/Core/Connectivity.dart';
import 'package:together/Core/FileIO.dart';
import 'package:together/Core/Logger.dart';
import 'package:together/Core/Misc.dart';
import 'package:together/Core/SnapshotLoader.dart';
import 'package:together/Model/Message.dart';
import 'package:together/Server/Server.dart';
import 'package:together/View/Bubble.dart';

class ChatViewModel extends SnapshotLoader {
  final fio = FileIO();

  List<Message> _messages = [];
  String _sender;
  String background = "res/bg1.jpg";

  String title = "Together";

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  StreamSubscription _connectionChangeStream;

  TextEditingController textController = TextEditingController();

  Stream<List<Message>> _messagesStream =
      Server.instance.database.messagesStream;
  Stream<List<Message>> get messagesStream => _messagesStream;

  var _isSendingStreamController = BehaviorSubject<bool>();
  Stream<bool> get isSending => _isSendingStreamController.stream;
  bool get sendingInProgress => _isSendingStreamController.stream.value;

  var _isConfiguringStreamController = BehaviorSubject<bool>();
  Stream<bool> get isConfiguring => _isConfiguringStreamController.stream;

  var _textStreamController = BehaviorSubject<String>();
  Function(String) get textChanged => _textStreamController.sink.add;
  bool get textIsEmpty => _textStreamController.stream.value == "";

  var _imagesStreamController = BehaviorSubject<List<Asset>>();
  Stream<List<Asset>> get imagesStream => _imagesStreamController.stream;
  bool get imagesIsEmpty => _imagesStreamController.stream.value == null;

  var _selectedMessagesStreamController = BehaviorSubject<List<int>>();
  Stream<List<int>> get selectedMessagesStream =>
      _selectedMessagesStreamController.stream;

  var _isEditingModeStreamController = BehaviorSubject<bool>();
  Stream<bool> get isEditingModeStream => _isEditingModeStreamController.stream;

  var _containerAlignmentStreamController = BehaviorSubject<Alignment>();
  Stream<Alignment> get containerAlignmentStream => _containerAlignmentStreamController.stream;

  Stream<bool> get canSend {
    return Rx.combineLatest3(_textStreamController.stream,
        _imagesStreamController.stream, _isSendingStreamController, (t, i, s) {
      return (t != "" || i != null) && s == false;
    });
  }

  List<Message> get messages => _messages;

  @override
  void onDidLoad(AsyncSnapshot snapshot) {
    _messages = snapshot.data;

    if (connectionStatus.hasConnection == true) {
      Server.instance.database.readMessages(_messages, _sender);
    }
  }

  void init() async {
    _isConfiguringStreamController.sink.add(true);
    _textStreamController.sink.add("");
    _imagesStreamController.sink.add(null);
    _isSendingStreamController.sink.add(false);
    _isEditingModeStreamController.sink.add(false);
    _selectedMessagesStreamController.sink.add([]);

    await _init().whenComplete(() {
      _isConfiguringStreamController.sink.add(false);
    });

    _connectionChangeStream =
        connectionStatus.connectionChange.listen(_connectionChanged);

    bool hasConnection = await connectionStatus.checkConnection();

    if (hasConnection == true) {
      title = "Together";
    } else {
      title = "No Internet...";
    }
  }

  void fetchOlderData()
  {
    Server.instance.database.getMessagesBefore(_messages.last.timestamp);
  }

  void _connectionChanged(dynamic hasConnection) {
    if (hasConnection == false) {
      title = "No Internet...";
    } else {
      title = "Together";

//      if (_messages.isNotEmpty)
//        Server.instance.database.readMessages(_messages, _sender);
    }

    cancelEditing();
  }

  Future _init() async {
    await _setBackground();
    await _getSender();
  }

  Future _setBackground() async {
    String bg = await fio.readAsString(fio.BACKGROUND);
    if (bg != null && bg != "") {
      background = bg;
    }
  }

  Future _getSender() async {
    _sender = await Server.instance.auth.getCurrentUserUid();
  }

  void pickImages() async {
    List<Asset> result;
    try {
      result =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    } on Exception catch (e) {
      logError(this.toString(), e.toString());
    }

    _imagesStreamController.sink.add(result);
  }

  void removeImage(Asset image) {
    var images = _imagesStreamController.stream.value;

    images.remove(image);
    if (images.length == 0) images = null;

    _imagesStreamController.sink.add(images);
  }

  // TODO: send images and then wait for upload confirmation
  void sendMessage() async {
    var images = _imagesStreamController.stream.value;

    final allUsers = await Server.instance.database.getAllUsers();
    final receiver = await Server.instance.auth.getOtherUser(_sender, allUsers);

    if (!textIsEmpty) {
      // TODO: no isSending flag???
      String id = Server.instance.database.createDocumentIdAt("chat");

      Message message = Message(_textStreamController.stream.value, _sender,
          DateTime.now(), [], false, id, "text");

      Server.instance.database
          .sendMessage(message, _sender, receiver)
          .whenComplete(() {
        if (images == null) {
          // _reset();
        }
      });
    }

    if (images != null) {
      _isSendingStreamController.sink.add(true);

      for (int i = 0; i < images.length; i++) {
        String id = Server.instance.database.createDocumentIdAt("chat");
        ByteData data = await images[i].getByteData(quality: 80);
        List<String> imgInfo =
            await Server.instance.storage.uploadPhoto("chat", id, data);

        Message message = Message("[Photo]", _sender, DateTime.now(),
            [imgInfo[1]], false, id, "photo");

        Server.instance.database
            .sendMessage(message, _sender, receiver)
            .whenComplete(() {
          if (i == images.length - 1) {
            // _reset();
          }
        });
      }
    }

    _reset();
  }

  void copyMessages() {
    var _selectedMessages = _selectedMessagesStreamController.stream.value;

    String _textToCopy = '';

    if (_selectedMessages.length > 1) {
      for (int k = 0; k < _selectedMessages.length; k++) {
        if (k != _selectedMessages.length - 1) {
          _textToCopy += _messages[_selectedMessages[k]].text + "\n\n";
        } else {
          _textToCopy += _messages[_selectedMessages[k]].text;
        }
      }
    } else {
      _textToCopy = _messages[_selectedMessages[0]].text;
    }

    copyToClipboard(_textToCopy);

    cancelEditing();
  }

  void deleteMessages() {
    var _selectedMessages = _selectedMessagesStreamController.stream.value;

    List<Message> selected = [];
    for (int i = 0; i < _selectedMessages.length; i++) {
      selected.add(_messages[_selectedMessages[i]]);
    }

    Server.instance.database.deleteMessages(selected);

    cancelEditing();
  }

  Widget createBubble(Message message, int pos) {
    String time = getTime(message.timestamp);
    String date = getFormattedDate(message.timestamp);

    int currentDate = getDate(message.timestamp);
    int previousDate = pos != _messages.length - 1
        ? getDate(_messages[pos + 1].timestamp)
        : currentDate - 1;
    bool newDay = currentDate - previousDate > 0;

    return Bubble(
      message: message,
      date: date,
      time: time,
      isMe: message.sender == _sender,
      selected: _selectedMessagesStreamController.stream.value.contains(pos),
      newDay: newDay,
    );
  }

  void chatOnTap(int pos) {
    var _selectedMessages = _selectedMessagesStreamController.stream.value;

    if (_selectedMessages.length > 0) {
      if (_selectedMessages.contains(pos)) {
        _selectedMessages.remove(pos);
        _selectedMessagesStreamController.sink.add(_selectedMessages);
        if (_selectedMessages.length == 0) {
          cancelEditing();
        }
      } else {
        _selectedMessages.add(pos);
        _selectedMessagesStreamController.sink.add(_selectedMessages);
      }
    }
  }

  bool chatOnLongPress(int pos) {
    var _selectedMessages = _selectedMessagesStreamController.stream.value;

    if (_selectedMessages.length == 0) {
      _selectedMessages.add(pos);
      _isEditingModeStreamController.sink.add(true);
      _selectedMessagesStreamController.sink.add(_selectedMessages);

      return true;
    }

    return false;
  }

  void cancelEditing() {
    _isEditingModeStreamController.sink.add(false);
    _selectedMessagesStreamController.sink.add([]);
  }

  void _reset() {
    textController.clear();

    _textStreamController.sink.add("");
    _imagesStreamController.sink.add(null);
    _isSendingStreamController.sink.add(false);
  }

  void dispose() {
    _isSendingStreamController.close();
    _textStreamController.close();
    _isConfiguringStreamController.close();
    _imagesStreamController.close();
    _selectedMessagesStreamController.close();
    _isEditingModeStreamController.close();
    _containerAlignmentStreamController.close();

    textController.dispose();
  }
}
