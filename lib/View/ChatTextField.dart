import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:together/ViewModel/ChatViewModel.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({
    Key key,
    @required this.viewModel,
    @required this.onTap
  }) : super(key: key);

  final ChatViewModel viewModel;
  final Function onTap;

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        focusNode: focusNode,
        controller: viewModel.textController,
        onChanged: viewModel.textChanged,
        onTap: onTap, // [optional] Maybe better without it
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            border: InputBorder.none,
            prefixIcon: IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: _onPick),
            hintText: "Напиши мне что-нибудь",
            suffixIcon: StreamBuilder(
                stream: viewModel.canSend,
                initialData: false,
                builder: (context, snapshot) {
                  return IconButton(
                      icon: Icon(Icons.send),
                      onPressed:
                      snapshot.data ? viewModel.sendMessage : null
                  );
                }
            ),
            suffix: StreamBuilder(
                stream: viewModel.isSending,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.data) {
                    return Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
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

  void _onPick()
  {
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