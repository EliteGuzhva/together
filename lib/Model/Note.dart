class Note {
  final String title;
  final String text;
  final int color;
  final DateTime timestamp;
  final String id;

  Note(this.title, this.text, this.color, this.timestamp, this.id);

  factory Note.fromMap(Map<String, dynamic> map) {
    return new Note(
        map["title"], map["text"], map["color"], map["timestamp"], map["id"]);
  }

  factory Note.createNew() {
    return new Note("Новая заметка", "", 0xFFCCEEFF, DateTime.now(), "");
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> noteMap;
    noteMap = {
      "title": this.title,
      "text": this.text,
      "color": this.color,
      "timestamp": this.timestamp,
      "id": this.id
    };

    return noteMap;
  }
}
