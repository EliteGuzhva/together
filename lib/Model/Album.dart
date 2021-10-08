class Album {
  String name;
  List<String> images;

  Album(this.name, this.images);

  factory Album.fromJson(Map<String, dynamic> parsedJson) {

    return new Album(parsedJson["name"],
        List<String>.from(parsedJson["images"]));
  }

  Map <String, dynamic> toJson() {
    return {
      "name": name,
      "images": images
    };
  }
}