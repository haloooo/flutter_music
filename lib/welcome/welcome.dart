import 'package:flutter_netease_music/welcome/skip_down_time.dart';
import 'package:flutter_netease_music/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() {
    return new _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage>
    implements OnSkipClickListener {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _delayedGoHomePage();
  }

  _delayedGoHomePage() {
    Future.delayed(new Duration(seconds: 5), () {
      _goHomePage();
    });
  }

  _goHomePage() {
//    Navigator.of(context).pushNamedAndRemoveUntil(
//        PageConstance.HOME_PAGE, (Route<dynamic> route) => false);
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new HomePage();
          },
        ), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Container(
          color: Colors.white,
          child: new Image.asset('assets/welcome.gif',fit: BoxFit.fill,),
          constraints: new BoxConstraints.expand(),
        ),
        new Container(
          child: Align(
            alignment: Alignment.topRight,
            child: new Container(
              padding: const EdgeInsets.only(top: 30.0, right: 20.0),
              child: new SkipDownTimeProgress(
                Colors.red,
                22.0,
                new Duration(seconds: 5),
                new Size(25.0, 25.0),
                skipText: "Skip",
                clickListener: this,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void onSkipClick() {
    _goHomePage();
  }
}