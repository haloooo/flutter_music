import 'package:flutter/material.dart';
import 'package:flutter_netease_music/searchSinger/show_singer_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchSingerPage extends StatefulWidget {
  @override
  _SearchSingerPageState createState() => _SearchSingerPageState();
}

class _SearchSingerPageState extends State<SearchSingerPage> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('查找歌手'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                      ),
//                      flex: 2,
                    ),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: (){
                          if(_textEditingController.text == ''){
                            Fluttertoast.showToast(msg: "请先输入歌手名😂😂");
                          }else{
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) {
                                  return ShowSingerPage(keyWord: _textEditingController.text,);
                                }
                            ));
                          }
                        }
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}