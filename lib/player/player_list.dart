import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';
import 'package:flutter_netease_music/player/player_home.dart';

class PlayerList extends StatefulWidget {

  @override
  State<PlayerList> createState() => new _PlayerListState();
}

class _PlayerListState extends State<PlayerList> with TickerProviderStateMixin{
  List _bannerData = [];
  List _itemData = [];

  @override
  void initState() {
    super.initState();
    _loadBannerData();
    _loadItemData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('听歌'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              brightness: Brightness.dark,
              expandedHeight: 250,
              flexibleSpace: new FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(top:10),
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Swiper(
                    itemCount: _bannerData.length,
                    itemBuilder: _swiperBuilder,
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.black54,
                          activeColor: Colors.white,
                        )),
                    viewportFraction: 0.8,
                    scale: 0.9,
                    control: new SwiperControl(),
                    scrollDirection: Axis.horizontal,
                    autoplay: true,
                    onTap: (index) => print('点击了第$index个'),
                  ),
                ),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildBuilderDelegate((context, index) => _sliverChildBuilderDelegate(index),
                  childCount: _itemData.length),
            )
          ],
        ),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      _bannerData[index]['pic_s192'],
      fit: BoxFit.fill,
    ));
  }

  Widget _sliverChildBuilderDelegate(int index){
    return Container(
        margin: EdgeInsets.all(20.0),//表示与外部元素的距离是20px
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.9, 0.0), // 10% of the width, so there are ten blinds.
              colors: [const Color(0xFFFFFFEE), const Color(0xFF999999)], // whitish to gray
              tileMode: TileMode.repeated, // repeats the gradient over the canvas
            )),
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  return PlayerHome(songId: _itemData[index]['song_id'],);
                }
            ));
          },
          child: Row(
            children: <Widget>[
              Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(_itemData[index]['pic_premium']),
                        fit: BoxFit.cover,
                      )
                  )
              ),
              Column(
                children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.only(top: 20,left: 10),
                        child: Text(_itemData[index]['title'], style: new TextStyle(fontWeight: FontWeight.w700),),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/3,
                        padding: EdgeInsets.only(top: 10,left: 60),
                        child: Text(_itemData[index]['author']),
                      )
                ],
              )
            ],
          ),
        )
    );
  }

  _loadBannerData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_ORDER);
    if(response.statusCode == 200){
      setState(() {
        _bannerData = response.data['data'];
      });
    }
  }

  _loadItemData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_RECOMMEND);
    if(response.statusCode == 200){
      setState(() {
        _itemData = response.data['data'];
      });
    }
  }
}