import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class RotateRecord extends AnimatedWidget {
  final String songPic;
  RotateRecord({Key key, Animation<double> animation,this.songPic})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      height: 150.0,
      width: 150.0,
      child: new RotationTransition(
          turns: animation,
          child: new Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(songPic),
              ),
            ),
          )),
    );
  }
}
