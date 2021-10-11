import 'package:flutter/material.dart';

import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';

import 'package:together/Core/UIFunctions.dart';
import 'package:together/Core/FileIO.dart';

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

  @override
  void initState() {
    super.initState();
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

  // TODO: download manually, read from memory and use ImageProvider
  void _downloadImage(BuildContext context) async {
    showSnack(context, "Скачивается...");
    setState(() {
      _isDownloading = true;
    });

    await ImageDownloader.downloadImage(widget.imageName)
        .whenComplete(() {
      showSnack(context, "Фотография загрузилась");
      setState(() {
        _isDownloading = false;
      });
    });

    // Download method for caching chat images
//    var documentDirectory = await getExternalStorageDirectory();
//    var firstPath = documentDirectory.path + "/chat_images";
//    var filePathAndName = documentDirectory.path +
//        '/chat_images/${widget.imageName.split("?")[0].split("/").last}';
//    await Directory(firstPath).create(recursive: true);
//    File file2 = new File(filePathAndName);
//
//    var response = await get(widget.imageName);
//    file2.writeAsBytesSync(response.bodyBytes);

//    setState(() {
//      showSnack(context, "Фотография загрузилась");
//      _isDownloading = false;
//    });
  }

  void _setAsBackground(BuildContext context) async {
    if (widget.fromInternet) {
      showSnack(context, "Фотография не скачана");
      return;
    }
    await fio.write(fio.BACKGROUND, widget.imageName).whenComplete(() {
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
