import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:infinite_cards/infinite_cards.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_netease_music/player/player_home.dart';
import 'package:flutter_netease_music/searchSinger/search_singer_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  ScrollController _scrollController = ScrollController(); //listview的控制器
  List _bannerData = [];
  List _orderListData = [];
  int offset = 1;
  String type = '2';
//  bool flag = true;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
    _loadOrderListData(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offset += 1;
        _loadOrderListData(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: _bannerData.length > 0 ? Container(
                child: CarouselSlider(
                  height: 200.0,
                  items: _bannerData.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return _orderItem(i);
                      },
                    );
                  }).toList(),
                ),
              ) : Container(),
            ),
            Container(
              height: MediaQuery.of(context).size.width,
              child: _orderListData.length > 0 ? ListView.builder(itemBuilder: _itemBuilder, itemCount: _orderListData.length,): Center(
                child: Text('没有找到歌曲哦，换个栏目试试吧'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawer(){
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/drawer.jpeg'),
              fit: BoxFit.fill
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: CircleAvatar(
                    child: Text('renjie'),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      return SearchSingerPage();
                    }
                ));
              },
              leading: Icon(Icons.settings,color: Colors.white,size: 30,),
              title: Text('查找歌手', style: TextStyle(color: Colors.white,fontSize: 30),),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) {
                return PlayerHome(songId: _orderListData[index]['song_id'],);
              }
          ));
        },
        child: Container(
          margin: EdgeInsets.all(20.0),//表示与外部元素的距离是20px
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.9, 0.0), // 10% of the width, so there are ten blinds.
                colors: [const Color(0xFFFFFFEE), const Color(0xFF999999)], // whitish to gray
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
              )),
          child: Row(
            children: <Widget>[
              Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(_orderListData[index]['pic_small']),
                        fit: BoxFit.cover,
                      )
                  )
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    margin: EdgeInsets.only(top: 20,left: 10),
                    child: Text(_orderListData[index]['title'], style: new TextStyle(fontWeight: FontWeight.w700),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,left: 60),
                    child: Text(_orderListData[index]['author']),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderItem(i){
    return GestureDetector(
      onTap: (){
        type = i['type'].toString();
        _loadOrderListData(false);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Image.network(i['pic_s192'],fit: BoxFit.cover,),
      ),
    );
  }

  _loadOrderListData(flag) async{
    Dio dio = new Dio();
    Response response;
    if(flag){

    } else {
      _orderListData.clear();
    }
    response=await dio.get(GankApi.API_GANK_MUSIC_ORDER_LIST + "type=$type&page=$offset");
    if(response.statusCode == 200 && response.data['code'] == 1){
      setState(() {
        if(offset == 1){
          _orderListData = response.data['data']['list'];
        }else{
          _orderListData.addAll(response.data['data']['list']);
        }
      });
    }else{
      setState(() {
        _orderListData = [];
      });
    }
  }

  _loadBannerData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_ORDER);
    if(response.statusCode == 200 && response.data['code'] == 1){
      setState(() {
        _bannerData = response.data['data'];
      });
    }
  }

  Future<Null> _onRefresh() async {
    setState(() {
      offset = 1;
      _loadOrderListData(true);
    });
  }

}