import 'package:flutter/material.dart';

import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'package:together/Core/UIFunctions.dart';
import 'package:together/Core/Logger.dart';
import 'package:together/View/AppThemeData.dart';
import 'package:together/View/ChatTextField.dart';
import 'package:together/ViewModel/ChatViewModel.dart';


class Chat extends StatefulWidget {
  Chat({Key key, this.viewModel}) : super(key: key);

  final ChatViewModel viewModel;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatViewModel _viewModel;

  final ScrollController _listController = new ScrollController();

  @override
  void initState() {
    _viewModel = widget.viewModel;

    _listController.addListener(() async {
      if (_listController.position.pixels ==
          _listController.position.maxScrollExtent) {
        logDebug(this.toString(), "fetching older messages...");
        _viewModel.fetchOlderData();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeData>();
    final _padding = theme.padding;

    return Scaffold(
      appBar: PreferredSize(
          child: StreamBuilder(
              stream: _viewModel.isEditingModeStream,
              initialData: false,
              builder: (context, snapshot) {
                return _appBarWidget(context, snapshot.data);
              }),
          preferredSize: Size.fromHeight(theme.chatTheme.appBarTheme.height)),
      body: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _viewModel.isConfiguring,
                initialData: true,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_viewModel.background),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: _padding / 2),
                      // color: _bgColor,
                      child: GestureDetector(
                          onTapUp: (details) {
                            unfocus(context);
                            vibrate(FeedbackType.light);
                            // _cancelEditing();  // Useful or inconvenient?
                          },
                          child: StreamBuilder(
                              stream: _viewModel.messagesStream,
                              builder: (context, snapshot) {
                                _viewModel.loadData(snapshot);

                                return _chatWidget(context);
                              })),
                    ));
                  }
                }),
            Divider(
              height: 2
            ),
            _imageContainerWidget(context),
            ChatTextField(
                viewModel: _viewModel,
                onTap: () => scrollToBottom(_listController))
          ],
        ),
      ),
    );
  }

  Widget _imageContainerWidget(BuildContext context) {
    final theme = context.watch<AppThemeData>();
    final _padding = theme.padding;

    return StreamBuilder(
        stream: _viewModel.imagesStream,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data != []) {
            var images = snapshot.data;

            return Container(
              margin: EdgeInsets.all(_padding / 2),
              height: 100 + _padding,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: images.map<Widget>((img) {
                    return Padding(
                      padding: EdgeInsets.only(right: _padding / 2),
                      child: Stack(
                        children: <Widget>[
                          AssetThumb(
                            asset: img,
                            width: 100,
                            height: 100,
                          ),
                          Positioned(
                              top: -10.0,
                              right: -10.0,
                              child: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () => _viewModel.removeImage(img)))
                        ],
                      ),
                    );
                  }).toList()),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _chatWidget(BuildContext context) {
    final theme = context.watch<AppThemeData>();
    final _padding = theme.padding;

    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: _padding / 2),
        controller: _listController,
        reverse: true,
        itemCount: _viewModel.messages.length,
        cacheExtent: 2000,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, pos) {
          return new GestureDetector(
              onTap: () {
                _viewModel.chatOnTap(pos);
              },
              onLongPress: () {
                bool didSelect = _viewModel.chatOnLongPress(pos);

                if (didSelect) {
                  vibrate(FeedbackType.selection);
                } else {
                  vibrate(FeedbackType.error);
                }
              },
              child: StreamBuilder(
                  stream: _viewModel.selectedMessagesStream,
                  initialData: [],
                  builder: (context, snapshot) {
                    return _viewModel.createBubble(
                        _viewModel.messages[pos], pos);
                  }));
        });
  }

  AppBar _appBarWidget(BuildContext context, bool editMode) {
    if (!editMode) {
      return AppBar(
        title: Text(_viewModel.title),
      );
    } else {
      List<Widget> actions = [
        IconButton(
          icon: Icon(
            Icons.content_copy,
          ),
          onPressed: () {
            _viewModel.copyMessages();
            showSnack(context, 'Текст скопирован');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.forward,
          ),
          onPressed: null,
        ),
        IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: _viewModel.deleteMessages)
      ];
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
          ),
          onPressed: _viewModel.cancelEditing,
        ),
        actions: actions,
      );
    }
  }
}
