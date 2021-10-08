import 'package:flutter/material.dart';
import 'package:together/Controller/AlbumViewer.dart';
import 'package:together/Core/UIFunctions.dart';
import 'package:together/Core/FileIO.dart';
import 'package:together/Model/Album.dart';

class SharedMedia extends StatefulWidget {
  SharedMedia({Key key}) : super(key: key);

  @override
  _SharedMediaState createState() => _SharedMediaState();
}

class _SharedMediaState extends State<SharedMedia> {
  final double _padding = 15.0;
  List<Album> _albums;
  final FileIO fio = FileIO();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<Album> albums = await fio.loadAlbums();
    setState(() {
      _albums = albums;
    });
  }

  void _addAlbum(BuildContext context) async {
    final TextEditingController _name = new TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Название альбома"),
            content: TextField(
              controller: _name,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_name.text == "") {
                      pop(context);
                    } else {
                      Album newAlbum = Album(_name.text, []);
                      setState(() {
                        _albums.add(newAlbum);
                      });
                      fio.updateAlbums(_albums).whenComplete(() {
                        pop(context);
                      });
                    }
                  },
                  child: Text("Добавить"))
            ],
          );
        });
  }

  void _deleteAlbum(int pos) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Удалить альбом ${_albums[pos].name}?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      _albums.removeAt(pos);
                    });
                    fio.updateAlbums(_albums).whenComplete(() {
                      pop(context);
                    });
                  },
                  child: Text("Да")),
              FlatButton(
                onPressed: () {
                  pop(context);
                },
                child: Text("Нет"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shared media"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add), onPressed: () => _addAlbum(context))
          ],
        ),
        body: _albums == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: _albums.length,
                itemBuilder: (context, pos) {
                  return GridTile(
                    child: Container(
                      padding: EdgeInsets.all(_padding),
                      child: GestureDetector(
                        onTap: () =>
                            pushPage(context, AlbumViewer(album: _albums[pos])),
                        onLongPress: () => _deleteAlbum(pos),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(
                              0.0)), // _padding for rounded corners
                          child: Image.asset(
                            _albums[pos].images.length > 0
                                ? _albums[pos]
                                    .images[_albums[pos].images.length - 1]
                                : "assets/defaultAlbumCover.jpg",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    footer: Padding(
                      padding: EdgeInsets.all(_padding + 10.0),
                      child: Text(
                        _albums[pos].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }));
  }
}
