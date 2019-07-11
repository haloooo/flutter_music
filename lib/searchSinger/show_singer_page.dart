import 'package:flutter/material.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';
import 'package:flutter_netease_music/searchSinger/show_singer_detail.dart';

class ShowSingerPage extends StatefulWidget {
  final String keyWord;
  ShowSingerPage({Key key, @required this.keyWord}) : super(key: key);

  @override
  _ShowSingerPageState createState() => _ShowSingerPageState();
}

class _ShowSingerPageState extends State<ShowSingerPage> {
  List _singerData = [];
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSingerData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _singerData.length > 0 ? NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
            child: ListView.builder(
              itemBuilder: _itemBuilder,
              itemCount: _singerData.length,
            ),
          )):Center(
        child: Text('没有找到对应的歌手信息'),
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
          background: Image.asset('assets/singerHeader.jpeg',fit: BoxFit.fill,),
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
                  return ShowSingerDetail(singerId: _singerData[index]['singerId'].toString(),);
                }
            ));
          },
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image:
                    DecorationImage(image: NetworkImage(_singerData[index]['singerPic']), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                margin: EdgeInsets.only(left: 8, top: 3, right: 8, bottom: 3),
                height: 50,
                width: 50,
              ),
              Text(
                _singerData[index]['singerName'],
                softWrap: true,
                textDirection: TextDirection.ltr,
                style:
                TextStyle(fontSize: 16, color: Color.fromARGB(255, 118, 117, 118)),
              ),
            ],
          ),
        )
    );
  }

  _loadSingerData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_GANK_MUSIC_SEARCH_SINGER + widget.keyWord);
    if(response.statusCode == 200 && response.data['code'] == 1){
      setState(() {
        _singerData = response.data['data'];
      });
    }
  }
}