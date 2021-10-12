import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';

import 'package:together/Core/UIFunctions.dart';
import 'package:together/Core/FileIO.dart';
import 'package:together/View/Themes.dart';

class ImageViewer extends StatefulWidget {
  ImageViewer(
      {Key key,
      @required this.image,
      @required this.imageName,
      this.fromInternet = false})
      : super(key: key);

  final Widget image;
  final String imageName;
  final bool fromInternet;

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final fio = FileIO();
  bool _isDownloading = false;
  String _imagePath;

  @override
  void initState() {
    super.initState();

    _imagePath = widget.fromInternet ? "" : widget.imageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: <Widget>[
        GestureDetector(
          child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.imageName,
                  child: Center(
                      child: PhotoView(
                              imageProvider: (widget.image as Image).image,
                              minScale: PhotoViewComputedScale.contained * 1.0,
                              maxScale: 5.0,
                            )),
                ),
                _isDownloading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Color(0x99000000),
            elevation: 0.0,
            // iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              PopupMenuButton<int>(
                  itemBuilder: (context) => _createMenuItems(context))
            ],
          ),
        )
      ]),
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    showSnack(context, "Скачивается...");
    setState(() {
      _isDownloading = true;
    });

    _imagePath = await fio.downloadImage(widget.imageName).whenComplete(() {
      showSnack(context, "Фотография загрузилась");
      setState(() {
        _isDownloading = false;
      });
    });
  }

  void _setAsBackground(BuildContext context) async {
    if (_imagePath == null || _imagePath == "") {
      await _downloadImage(context);
    }

    ThemeManager.instance.setChatBackground(_imagePath, () {
      showSnack(context, "Фон обновился");
    });
  }

  List<PopupMenuEntry<int>> _createMenuItems(BuildContext context) {
    List<PopupMenuEntry<int>> _actions = [
      PopupMenuItem(
          value: 1,
          child: FlatButton(
            child: Text('Установить как фон'),
            onPressed: () {
              pop(context);
              _setAsBackground(context);
            },
          ))
    ];
    if (widget.fromInternet) {
      _actions.add(
        PopupMenuItem(
            value: 0,
            child: FlatButton(
              child: Text('Скачать'),
              onPressed: () {
                pop(context);
                _downloadImage(context);
              },
            )),
      );
    }

    return _actions;
  }
}
