import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:together/Core/Logger.dart';
import 'package:together/Model/Message.dart';
import 'package:together/Model/Note.dart';
import 'package:together/Model/SimpleUserModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:together/Server/Firebase/StorageFirebase.dart';
import 'package:together/Server/Interface/DatabaseInterface.dart';

class DatabaseFirebase implements DatabaseInterface {
  // Firebase instance
  final database = FirebaseFirestore.instance;

  // create a singleton
  static final DatabaseFirebase _singleton = new DatabaseFirebase._internal();
  DatabaseFirebase._internal();

  // initialization methods
  static DatabaseFirebase getInstance() => _singleton;
  factory DatabaseFirebase() => _singleton;
  static DatabaseFirebase get instance => _singleton;

  // params
  final String _userCollectionName = "users";
  final String _noteCollectionName = "notes";
  final String _chatCollectionName = "chat";

  final StorageFirebase _storage = StorageFirebase();

  List<Message> _messages = [];
  List<String> _deletedMessages = [];
  List<String> _sentMessages = [];

  var _messagesStreamController = BehaviorSubject<List<Message>>();

  @override
  Stream<List<Message>> get messagesStream => _messagesStreamController.stream;

  // methods
  @override
  Future saveUserToDatabase(SimpleUser userData) async {
    DocumentReference documentReference =
        database.collection(_userCollectionName).doc(userData.uid);

    await documentReference
        .set({"email": userData.email, "uid": userData.uid});
  }

  @override
  Future getAllUsers() async {
    List<String> users;
    await database.collection(_userCollectionName).get().then((snap) {
      users = snap.docs.map<String>((doc) {
        return doc.id;
      }).toList();
    });

    return users;
  }

  @override
  String createDocumentIdAt(String collectionName) {
    String id = database.collection(collectionName).doc().id;

    return id;
  }

  @override
  Stream<List<Note>> getNotesStream() {
    return database
        .collection(_noteCollectionName)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map<Note>((doc) {
        Timestamp timestamp = doc["timestamp"] as Timestamp;
        Map<String, dynamic> docCopy = doc.data();
        docCopy["timestamp"] = timestamp.toDate();

        return Note.fromMap(docCopy);
      }).toList();
    });
  }

  @override
  Future updateNote(Note note) async {
    DocumentReference documentReference;

    if (note.id != "") {
      documentReference =
          database.collection(_noteCollectionName).doc(note.id);
    } else {
      documentReference = database.collection(_noteCollectionName).doc();
    }

    Map<String, dynamic> noteMap = note.toMap();
    noteMap["timestamp"] = Timestamp.now();
    noteMap["id"] = documentReference.id;

    documentReference.set(noteMap);
  }

  @override
  Future deleteNote(Note note) async {
    database.collection(_noteCollectionName).doc(note.id).delete();
  }

  Message messageFromDoc(DocumentSnapshot doc)
  {
    List<String> media = doc["media"].map<String>((val) {
      return val.toString();
    }).toList();

    DateTime timestamp = (doc["timestamp"] as Timestamp).toDate();

    Map<String, dynamic> docCopy = doc.data();
    docCopy["media"] = media;
    docCopy["timestamp"] = timestamp;
    docCopy["id"] = doc.id;

    return Message.fromMap(docCopy);
  }

  @override
  void getMessages() {
    Query query = database
        .collection(_chatCollectionName)
        .orderBy("timestamp", descending: true);

    Stream<QuerySnapshot> snapshots =
        query.limit(DatabaseInterface.messagesLimit).snapshots();

    snapshots.listen((data) {
      if (_messages.isEmpty) {
        _messages = data.docs.map<Message>((doc) {
          return messageFromDoc(doc);
        }).toList();

        logDebug(this.toString(), "Initial messages fetching");

        _messagesStreamController.sink.add(_messages);
      } else {
        logDebug(this.toString(), "Secondary messages fetching");

        data.docChanges.forEach((change) {
          Message currentMessage = messageFromDoc(change.doc);
          int ind = _messages.indexWhere((m) => m.id == currentMessage.id);

          if (change.type == DocumentChangeType.added)
            {
              if (ind == -1)
                {
                  if (currentMessage.timestamp.isAfter(_messages[0].timestamp))
                    _messages.insert(0, currentMessage);
                  else
                    _messages.add(currentMessage);
                }
              else
                {
                  if (_sentMessages.contains(currentMessage.id))
                    {
                      _messages[ind].isLoading = false;
                      _sentMessages.remove(currentMessage.id);
                    }
                }
            }
          else if (change.type == DocumentChangeType.modified)
            {
              _messages[ind] = currentMessage;
            }
          else if (change.type == DocumentChangeType.removed)
            {
              if (ind != -1)
                _messages.removeAt(ind);

              if (_deletedMessages.contains(currentMessage.id))
                {
                  _deletedMessages.remove(currentMessage.id);
                }
            }
        });

        _messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        _messagesStreamController.sink.add(_messages);
      }
    });
  }

  // TODO: progress indicator
  @override
  void getMessagesBefore(DateTime lastTimestamp) async {
    Query query = database
        .collection(_chatCollectionName)
        .orderBy("timestamp", descending: true);

    // start after
    query = query.startAfter([Timestamp.fromDate(lastTimestamp)]);

    QuerySnapshot snapshots = await query
        .limit(DatabaseInterface.messagesLimit)
        .get();

    List<Message> loadedMessages = snapshots.docs.map<Message>((doc) {
      return messageFromDoc(doc);
    }).toList();

    _messages.addAll(loadedMessages);
    _messagesStreamController.sink.add(_messages);
  }

  @override
  Future deleteMessages(List<Message> messages) async {
    WriteBatch batch = database.batch();

    for (int i = 0; i < messages.length; i++) {
      DocumentReference messageReference = database
          .collection(_chatCollectionName)
          .doc(messages[i].id);

      _deletedMessages.add(messages[i].id);

      batch.delete(messageReference);

      if (messages[i].type == "photo")
        _storage.deletePhoto(_chatCollectionName, messages[i].id + ".jpg");
    }

    batch.commit();
  }

  @override
  Future readMessages(List<Message> messages, String currentUser) async {
    WriteBatch batch = database.batch();

    for (int i = 0; i < messages.length; i++) {
      if (messages[i].sender != currentUser && messages[i].delivered == false) {
        DocumentReference messageReference =
            database.collection(_chatCollectionName).doc(messages[i].id);

        batch.update(messageReference, <String, dynamic>{'delivered': true});
      }
    }

    batch.commit();
  }

  @override
  Future sendMessage(Message message, String sender, String receiver) async {
    DocumentReference documentReference = database
        .collection(_chatCollectionName)
        .doc(message.id);

//    if (message.id != "") {
//      documentReference =
//          database.collection(_chatCollectionName).document(message.id);
//    } else {
//      documentReference = database.collection(_chatCollectionName).document();
//    }

    // String id = documentReference.documentID;
    _sentMessages.add(message.id);
    // message.id = id;
    message.isLoading = true;
    _messages.insert(0, message);
    _messagesStreamController.sink.add(_messages);

    Map<String, dynamic> messageMap = message.toMap();
    messageMap["timestamp"] = Timestamp.now();
    messageMap["receiver"] = receiver;

    documentReference.set(messageMap);
  }

  @override
  bool hasCachedMessages()
  {
    return _messages.isNotEmpty;
  }

  @override
  List<Message> getCachedMessages()
  {
    return _messages;
  }

  @override
  Future saveDeviceToken(String token, String userId) async {
    if (token != null) {
      var tokens = database.collection(_userCollectionName).doc(userId);

      await tokens.update({'token': token});
    }
  }

  @override
  Future emptyRequest() async {
    // ignore: missing_return
    await database
        // ignore: missing_return
        .runTransaction((Transaction tx) {})
        .timeout(Duration(seconds: 5));
  }

  void dispose() {
    _messagesStreamController.close();
  }
}
