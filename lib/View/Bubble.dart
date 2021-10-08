import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:together/Model/Message.dart';
import 'package:together/Controller/ImageViewer.dart';
import 'package:together/Core/UIFunctions.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {this.message,
      this.date,
      this.time,
      this.isMe,
      this.selected,
      this.newDay});

  final Message message;
  final String date, time;
  final isMe, selected, newDay;

//  Color myColor = Color(0xFF476dd6);
  Color myColor = Color(0xFF216695);

  @override
  Widget build(BuildContext context) {
    final String messageText = message.text;
    Color bg = selected ? Colors.blueGrey : isMe ? myColor : Colors.white;
    final textColor = isMe ? Colors.white : Colors.black;
    final timeColor = isMe ? Colors.white70 : Colors.black38;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = message.isLoading
        ? Icons.access_time
        : message.delivered ? Icons.done_all : Icons.done;
    final radiusSize = 20.0;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(radiusSize),
            topLeft: Radius.circular(radiusSize),
            bottomLeft: Radius.circular(radiusSize),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(radiusSize),
            bottomRight: Radius.circular(radiusSize),
            topRight: Radius.circular(radiusSize),
          );
    final _screenWidth = MediaQuery.of(context).size.width;
    final margin = isMe
        ? EdgeInsets.only(
            top: 3.0, bottom: 3.0, left: _screenWidth * 0.3, right: 3.0)
        : EdgeInsets.only(
            top: 3.0, bottom: 3.0, left: 3.0, right: _screenWidth * 0.3);

    Widget mainBody;

    switch (message.type) {
      case "text":
        mainBody = Padding(
          padding: EdgeInsets.only(right: 48.0),
          child: LinkText(
            messageText,
            textStyle: TextStyle(fontSize: 16.0, color: textColor),
          ),
        );
        break;
      case "photo":
        Widget currentImage = CachedNetworkImage(
          placeholder: (context, s) {
            return Container(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
                width: 200.0,
                height: 200.0);
          },
          imageUrl: message.media[0],
        );

        Widget image = Image(image: CachedNetworkImageProvider(message.media[0], scale: 1.0));

        mainBody = GestureDetector(
          onTap: () => pushPage(
              context,
              ImageViewer(
                image: image,
                imageName: message.media[0],
                fromInternet: true,
              )),
          child: Padding(
            // padding: EdgeInsets.only(bottom: 20.0),
            padding: EdgeInsets.zero,
            child: Container(
//              width: 200,
//              height: 200,
              child: ClipRRect(
                borderRadius: radius,
                child: Hero(
                  tag: message.media[0],
                  child: currentImage,
                  flightShuttleBuilder: (context, anim, direction, fromContext, toContext) {
                      final Hero toHero = toContext.widget;
                      if (direction == HeroFlightDirection.pop) {
                          return FadeTransition(
                                  opacity: AlwaysStoppedAnimation(0),
                                  child: toHero.child
                          );
                      } else {
                          return toHero.child;
                      }
                  }
                ),
              ),
            ),
          ),
        );
        break;
      default:
        mainBody = Container();
        break;
    }

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        newDay
            ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: _screenWidth * 0.3),
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius:
                        BorderRadius.all(Radius.circular(radiusSize / 2))),
                child: Text(
                  date,
                  style: TextStyle(
                      color: Color(0xFF00538a),
                      fontSize: 22.0,
                      fontFamily: "Qwigley"),
                ))
            : Container(),
        Container(
          margin: margin,
          padding: message.type == "text"
              ? const EdgeInsets.all(10.0)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              mainBody,
              Positioned(
                bottom: message.type == "text" ? 0.0 : 10.0,
                right: message.type == "text" ? 0.0 : 10.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: message.type == "photo"
                              ? Colors.white
                              : timeColor,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 14.0,
                      color: message.delivered ? Colors.green : Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
