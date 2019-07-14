import 'dart:convert';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';
import 'package:flutter_netease_music/picture/entity.dart';
import 'package:flutter_netease_music/picture/eventbus.dart';
import 'package:flutter_netease_music/picture/main_card_widget.dart';
import 'package:flutter_netease_music/picture/pull_drag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_netease_music/index/index.dart';
import 'package:carousel_slider/carousel_slider.dart';



class PicturePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darg Card Sample',
      home: Scaffold(
        body: HomePager(),
      ),
    );
  }
}

class HomePager extends StatefulWidget {
  @override
  _HomePagerState createState() => _HomePagerState();
}

class _HomePagerState extends State<HomePager> {
  List<CardEntity> _cardList;
  int offset = 2;

  List<ToolBarEntity> _toolbarList;

  initState() {
    super.initState();
//    _loadJson();
    _loadCardData('4e4d610cdf714d2966000000');
    _loadHeaderData();
//    var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//    print("permission status is " + permission.toString());
//    PermissionHandler().requestPermissions(<PermissionGroup>[
//      PermissionGroup.storage, // 在这里添加需要的权限
//    ]);

  }

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/mock/jk_daily_cards.json');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: PullDragWidget(
          dragHeight: 100,
          parallaxRatio: 0.4,
          thresholdRatio: 0.3,
          header: _createHeader(),
          child: _createContent(),
        ));
  }

  _onHeaderItemClick(ToolBarEntity item) {
    Fluttertoast.showToast(msg: item.name);
  }

  Widget _createHeader() {
    Widget header;
    if (_toolbarList == null || _toolbarList.length == 0) {
      header = Text("Loading...");
    } else {
      header = CarouselSlider(
        items: _toolbarList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return _orderItem(i);
            },
          );
        }).toList(),
      );
    }

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10), child: header);
  }

  Widget _orderItem(i){
    return GestureDetector(
        onTap: (){
          _loadNextCardData(i.id);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.network(
                      i.cover,
                      fit: BoxFit.cover,
                    ),
                    Container(color: const Color(0x5a000000)),
                    Container(
                      margin: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        i.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        maxLines: 4,
                      ),
                    )
                  ]
              )
          ),
        )
    );
  }

  Widget _createContent() {
    if (_cardList == null || _cardList.length == 0) {
      return Container(
        child: Text(
          "Loading...",
        ),
        alignment: Alignment.center,
      );
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: _createOptMenus(),
              )),
          CardStackWidget(
            cardList: _cardList,
          )
        ],
      );
    }
  }

  Widget _createOptMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        _createMenu("assets/drawable/ic_discover_next_card_back.png",
//                () => Fluttertoast.showToast(msg: "coming soon...😂😂")),
        _createMenu("assets/drawable/ic_discover_next_card_back.png",
                () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  return Index();
                }
            ))),
        _createMenu("assets/drawable/ic_discover_more.png",
                () => bus.emit("openCard", true)),
//        _createMenu("assets/drawable/ic_discover_next_card_right.png",
//                ()=>_loadNextCardData('1')),
      ],
    );
  }

  _launchURL() async {
    const url = 'https://github.com/HitenDev/FlutterDragCard';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showAboutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("About"),
            content: Text("Show me the code."),
            actions: <Widget>[
              FlatButton(child: Text("cancel"),textColor: Colors.grey,onPressed: (){
                Navigator.of(context).pop();
              },),
              FlatButton(child: Text("github"),onPressed: (){
                _launchURL();
                Navigator.of(context).pop();
              },)
            ],
          );
        });
  }

  Widget _createMenu(String picUrl, GestureTapCallback onTap) {
    return Expanded(
        child: Container(
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  picUrl,
                  width: 48,
                  height: 48,
                ))));
  }

  _loadCardData(id) async{
    List<CardEntity> cardEntities = List();
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_PICTURE_TYPE + '/' + id + '/vertical?limit=100000');
    if(response.statusCode == 200 && response.data['msg'] == "success"){
      setState(() {
        List dataList = response.data['res']['vertical'];
        for (Map item in dataList) {
          int views = item["views"];
          int ncos = item["ncos"];
          int rank = item["rank"];
          List tag = item["tag"];
          String wp = item["wp"];
          bool xr = item["xr"];
          bool cr = item["cr"];
          int favs = item["favs"];
          double atime = item["atime"];
          String id = item["id"];
          String desc = item["desc"];
          String thumb = item["thumb"];
          String img = item["img"];
          List cid = item["cid"];
          List url = item["url"];
          String rule = item["rule"];
          String preview = item["preview"];
          String store = item["store"];
          if (url != null) {
            cardEntities.add(CardEntity(views, ncos, rank, tag, wp, xr, cr,
                favs, atime, id, desc, thumb, img,
                cid, url, rule, preview, store));
          }
        }
        _cardList = cardEntities;
      });
    }
  }

  _loadHeaderData() async{
    List<ToolBarEntity> toolBarEntities = List();
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_PICTURE_TYPE);
    if(response.statusCode == 200 && response.data['msg'] == "success"){
      setState(() {
        List dataList = response.data['res']['category'];
        for (Map item in dataList) {
          int count = item["count"];
          String ename = item["ename"];
          String rname = item["rname"];
          String cover_temp = item["cover_temp"];
          String name = item["name"];
          String cover = item["cover"];
          int rank = item["rank"];
          List filter = item["filter"];
          int sn = item["sn"];
          String icover = item["icover"];
          double atime = item["atime"];
          int type = item["type"];
          String id = item["id"];
          String picasso_cover = item["picasso_cover"];
          toolBarEntities.add(ToolBarEntity(count, ename, rname, cover_temp, name, cover, rank, filter, sn, icover, atime, type, id, picasso_cover));
        }
        _toolbarList = toolBarEntities;
      });
    }
  }

  Future<Null> _loadNextCardData(id) async {
    setState(() {
      offset += 1;
      _loadCardData(id);
    });
  }
}