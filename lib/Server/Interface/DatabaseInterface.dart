import 'package:together/Model/Message.dart';
import 'package:together/Model/Note.dart';
import 'package:together/Model/SimpleUserModel.dart';

abstract class DatabaseInterface {
  static int messagesLimit = 100;

  Future saveUserToDatabase(SimpleUser userData);
  Future getAllUsers();

  Stream<List<Note>> getNotesStream();
  Future updateNote(Note note);
  Future deleteNote(Note note);

  void getMessages();
  void getMessagesBefore(DateTime lastTimestamp);
  Future sendMessage(Message message, String sender, String receiver);
  Future readMessages(List<Message> messages, String currentUser);
  Future deleteMessages(List<Message> messages);
  bool hasCachedMessages();
  List<Message> getCachedMessages();
  Stream<List<Message>> get messagesStream;

  String createDocumentIdAt(String collectionName);

  Future saveDeviceToken(String token, String userId);

  Future emptyRequest();
}
