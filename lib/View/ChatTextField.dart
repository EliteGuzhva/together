import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:together/View/AppThemeData.dart';
import 'package:together/ViewModel/ChatViewModel.dart';


class ChatTextField extends StatelessWidget {
  ChatTextField({Key key, @required this.viewModel, @required this.onTap})
      : super(key: key);

  final ChatViewModel viewModel;
  final Function onTap;

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeData>().chatTheme.textFieldTheme;

    return Container(
      child: TextField(
        style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground
        ),
        focusNode: focusNode,
        controller: viewModel.textController,
        onChanged: viewModel.textChanged,
        onTap: onTap, // [optional] Maybe better without it
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.background,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            border: InputBorder.none,
            prefixIcon:
                IconButton(icon: Icon(theme.attachIcon), onPressed: _onPick),
            hintText: theme.hintText,
            suffixIcon: StreamBuilder(
                stream: viewModel.canSend,
                initialData: false,
                builder: (context, snapshot) {
                  return IconButton(
                      icon: Icon(theme.sendIcon),
                      onPressed: snapshot.data ? viewModel.sendMessage : null);
                }),
            suffix: StreamBuilder(
                stream: viewModel.isSending,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data) {
                    return Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primaryVariant),
                      ),
                      width: 10,
                      height: 10,
                    );
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                })),
      ),
    );
  }

  void _onPick() {
    focusNode.unfocus();
    focusNode.canRequestFocus = false;

    viewModel.pickImages();

    Future.delayed(Duration(milliseconds: 100), () {
      focusNode.canRequestFocus = true;
    });
  }

//  void _onSend()
//  {
//    focusNode.unfocus();
//    focusNode.canRequestFocus = false;
//
//    viewModel.sendMessage();
//
//    Future.delayed(Duration(milliseconds: 100), () {
//      focusNode.canRequestFocus = true;
//    });
//  }
}

