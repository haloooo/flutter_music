import 'package:flutter/material.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';
import 'package:flutter_netease_music/player/player_home.dart';

class ShowSingerDetail extends StatefulWidget {
  final String singerId;
  ShowSingerDetail({Key key, @required this.singerId}) : super(key: key);

  @override
  _ShowSingerDetailState createState() => _ShowSingerDetailState();
}

class _ShowSingerDetailState extends State<ShowSingerDetail> {
  int offset = 1;
  String avatar = '';
  String constellation = '';
  String intro = '';
  String name = '';
  List _singerSongData = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSingerDetailData();
    _loadSingerSongData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offset += 1;
        _loadSingerSongData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
            child: ListView.builder(
              itemBuilder: _itemBuilder,
              itemCount: _singerSongData.length,
              controller: _scrollController,
            ),
          )
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,    //标题居中
        expandedHeight: 200.0,  //展开高度200
        floating: false,  //不随着滑动隐藏标题
        pinned: false,    //固定在顶部
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(name),
          background: Image.network(avatar,fit: BoxFit.fill,),
        ),
      )
    ];
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 5),
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) {
                  return PlayerHome(songId: _singerSongData[index]['song_id'].toString(),);
                }
            ));
          },
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    image:
                    DecorationImage(image: NetworkImage(_singerSongData[index]['pic_big']), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                margin: EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
                height: 50,
                width: 50,
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        _singerSongData[index]['title'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text('(' + _singerSongData[index]['publishtime'] + ')',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey))
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text( _singerSongData[index]['si_proxycompany'],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey))
                    ],
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  _loadSingerDetailData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_GET_SINGER_DETAIL + widget.singerId);
    if(response.statusCode == 200 && response.data['code'] == 1){
      setState(() {
        avatar = response.data['data']['avatar'];
        constellation = response.data['data']['constellation'];
        intro = response.data['data']['intro'];
        name = response.data['data']['name'];
      });
    }
  }

  _loadSingerSongData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_GET_SINGER_SONGS + widget.singerId + "&page=" + offset.toString());
    if(response.statusCode == 200 && response.data['code'] == 1){
      setState(() {
        if(offset == 1){
          _singerSongData = response.data['data']['list'];
        }else{
          _singerSongData.addAll(response.data['data']['list']);
        }
      });
    }
  }



}