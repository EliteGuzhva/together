import 'package:flutter/material.dart';
import 'package:together/Core/UIFunctions.dart';
import 'package:together/Model/Album.dart';
import 'package:together/Controller/ImageViewer.dart';

class AlbumViewer extends StatefulWidget {
  AlbumViewer({Key key, this.album}) : super(key: key);

  final Album album;

  @override
  _AlbumViewerState createState() => _AlbumViewerState();
}

class _AlbumViewerState extends State<AlbumViewer> {
  final double _padding = 15.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.album.name),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: null)
          ],
        ),
        body: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemCount: widget.album.images.length,
            itemBuilder: (context, pos) {
              Widget currentImage = Image.asset(
                widget.album.images[pos],
                fit: BoxFit.fitWidth,
              );
              
              return Container(
                child: GestureDetector(
                  onTap: () => pushPage(
                      context,
                      ImageViewer(
                        image: currentImage,
                        imageName: widget.album.images[pos],
                      )),
                  child: Hero(
                      tag: widget.album.images[pos],
                      child: currentImage),
                ),
              );
            }));
  }
}
