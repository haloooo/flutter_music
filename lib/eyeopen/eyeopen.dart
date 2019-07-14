import 'package:flutter/material.dart';
import 'package:flutter_netease_music/utils/API.dart';
import 'package:dio/dio.dart';

class EyeOpen extends StatefulWidget {
  @override
  _EyeOpenState createState() => _EyeOpenState();
}

class _EyeOpenState extends State<EyeOpen> with TickerProviderStateMixin{
  List _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategoriesData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: _categories.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //单个子Widget的水平最大宽度
            maxCrossAxisExtent: 200,
            //水平单个子Widget之间间距
            mainAxisSpacing: 20.0,
            //垂直单个子Widget之间间距
            crossAxisSpacing: 10.0
        ),
        itemBuilder: (BuildContext context, int index) {
          return getItemContainer(_categories[index]);
        },
      ),
    );
  }

  Widget getItemContainer(item){
    return Container(
      width: 5.0,
      height: 5.0,
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blue,

    );
  }

  _loadCategoriesData() async{
    Dio dio = new Dio();
    Response response=await dio.get(GankApi.API_EYEOPEN_CATEGPRIES);
    if(response.statusCode == 200){
      setState(() {
        _categories = response.data;
      });
    }
  }
}