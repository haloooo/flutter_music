import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_netease_music/anims/needle_anim.dart';
import 'package:flutter_netease_music/anims/record_anim.dart';
import 'package:flutter_netease_music/player_page.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';

const String coverArt =
    'http://qukufile2.qianqian.com/data2/pic/09F3D02F6BF46E1425A81A0E6744B1B8/252053022/252053022.jpg@s_2,w_300,h_300',
    mp3Url = 'http://audio01.dmhmusic.com/71_53_T10046006487_128_4_1_0_sdk-cpm/0209/M00/64/38/ChR461sYv_SAIbzEACAP7fGWfhU628.mp3?xcode=d50c8d7a4474e6b14bdbd3f63529badf2a7f208';
final GlobalKey<PlayerState> musicPlayerKey = new GlobalKey();

class PlayerHome extends StatefulWidget {
  final String songId;

  PlayerHome({Key key, @required this.songId}) : super(key: key);

  @override
  State<PlayerHome> createState() => new _PlayerHomeState();
}

class _PlayerHomeState extends State<PlayerHome> with TickerProviderStateMixin{
  String songName;
  String artistName;
  String albumName;
  String songPic = '';
  String lrcLink;
  String songLink;
  String format;

  AnimationController controller_record;
  Animation<double> animation_record;
  Animation<double> animation_needle;
  AnimationController controller_needle;
  final _rotateTween = new Tween<double>(begin: -0.15, end: 0.0);
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  void initState() {
    super.initState();
    _loadMusicDetailData();
    controller_record = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animation_record =
    new CurvedAnimation(parent: controller_record, curve: Curves.linear);

    controller_needle = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation_needle =
    new CurvedAnimation(parent: controller_needle, curve: Curves.linear);

    animation_record.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller_record.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controller_record.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller_record.dispose();
    controller_needle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(songPic),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                Colors.black54,
                BlendMode.overlay,
              ),
            ),
          ),
        ),
        new Container(
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Opacity(
                opacity: 0.6,
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
            )),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Container(
              child: Text(
                "$songName",
                style: new TextStyle(fontSize: 13.0),
              ),
            ),
          ),
          body: new Stack(
            alignment: const FractionalOffset(0.5, 0.0),
            children: <Widget>[
              new Stack(
                alignment: const FractionalOffset(0.7, 0.1),
                children: <Widget>[
                  new Container(
                    child: RotateRecord(
                        animation: _commonTween.animate(controller_record),songPic: songPic,),
                    margin: EdgeInsets.only(top: 100.0),
                  ),
                  new Container(
                    child: new PivotTransition(
                      turns: _rotateTween.animate(controller_needle),
                      alignment: FractionalOffset.topLeft,
                      child: new Container(
                        width: 100.0,
                        child: new Image.asset("images/play_needle.png"),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: new Player(
                  onError: (e) {
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text(e),
                      ),
                    );
                  },
                  onPrevious: () {},
                  onNext: () {},
                  onCompleted: () {},
                  onPlaying: (isPlaying) {
                    if (isPlaying) {
                      controller_record.forward();
                      controller_needle.forward();
                    } else {
                      controller_record.stop(canceled: false);
                      controller_needle.reverse();
                    }
                  },
                  key: musicPlayerKey,
                  color: Colors.white,
                  audioUrl: "$songLink",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _loadMusicDetailData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_DETAIL + widget.songId);
    if(response.statusCode == 200){
      setState(() {
        songName = response.data['data']['songName'];
        songLink = response.data['data']['songLink'];
        songPic = response.data['data']['songPic'];
      });
    }
  }

}