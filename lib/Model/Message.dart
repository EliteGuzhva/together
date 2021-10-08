enum MessageType
{
  TEXT,
  PHOTO
}

class Message {
  final String text;
  final String sender;
  final DateTime timestamp;
  final List<String> media;
  final bool delivered;
  String id;
  final String type;

  bool isLoading = false;

  Message(this.text, this.sender, this.timestamp, this.media, this.delivered, this.id, this.type);

  factory Message.fromMap(Map<String, dynamic> map) {
    return new Message(
        map["text"],
        map["sender"],
        map["timestamp"],
        map["media"],
        map["delivered"],
        map["id"],
        map["type"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> messageMap;
    messageMap = {
      "text": this.text,
      "sender": this.sender,
      // "receiver": receiver,
      "timestamp": this.timestamp,
      "media": this.media,
      "delivered": this.delivered,
      "id": this.id,
      "type": this.type
    };

    return messageMap;
  }
}