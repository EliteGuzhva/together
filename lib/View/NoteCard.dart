import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:together/Core/Misc.dart';
import 'package:together/Model/Note.dart';
import 'package:together/View/AppThemeData.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({Key key,
    @required this.note})
      : super(key: key);

  final Note note;

  final double _cardRadius = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppThemeData>();
    final _padding = theme.padding;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_cardRadius))),
      color: theme.colorPalette.getColorByName(note.color),
      margin: EdgeInsets.only(
          left: _padding, right: _padding, top: _padding),
      child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    note.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _padding),
                    child: Text(
                      note.text,
                      maxLines: 5,
                      style: TextStyle(
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
              Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(getFormattedDate(
                          note.timestamp)),
                      Text(getTime(note.timestamp))
                    ],
                  ))
            ],
          )),
    );
  }
}
