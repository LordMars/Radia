import 'package:flutter/material.dart';
import './chat_page.dart';
import './friends_page.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:location/location.dart';


class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage> {


  String api_key = "AIzaSyDaTLHqDQpGuN-IOTmgbUHYRS-oRE5PM0I";
  Map<String,double> _currentLocation;
  StreamSubscription<Map<String,double>> _locationSubscription;
  Location _location = new Location();

  bool currentWidget = true;

  Image image;

  @override
  initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged.listen((Map<String,double> result) {
          setState(() {
            _currentLocation = result;
          });
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String,double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.


    try {
      location = await _location.getLocation;
    } on PlatformException {
      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _currentLocation = location;
    });

  }

  @override
  Widget build(BuildContext context){
      // Temporary API key included in url

      MediaQueryData media = MediaQuery.of(context);
      double devicepixelratio = media.devicePixelRatio;
      Size screensize = media.size;
      double device_width = screensize.width * devicepixelratio ;
      double device_height = screensize.height * devicepixelratio;

      double ratio = device_height/device_width;

      int true_height = 640;
      int true_width = (640/ratio).round();

      print("$device_width");
      print("$device_height");
      print("$true_width");
      print("$true_height");

      final double lat = _currentLocation["latitude"];
      final double long = _currentLocation["longitude"];
      image = new Image.network("https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=15&size=${true_width}x${true_height}&scale=2&key=$api_key");
      currentWidget = !currentWidget;

    // TODO - Stop minor overflows
    return new Material(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Stack(
            children: [
              new Container(
                child: image,
              )
            ],
            overflow: Overflow.clip
          )
        ]
      )
    );
  }
}


//button that leads to the friends list
class GoToFriends extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      child: new Text('Friends List'),
      onPressed:  (){
        Navigator.push(
          context,
          friendSwitch(),
        );
      }
    );
  }
}

//button that leads to the chat page
class GoToChat extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new RaisedButton(
      child: new Text('Chat page'),
      onPressed:  (){
        Navigator.push(
          context,
          chatSwitch(),
        );
      }
    );
  }
}

MaterialPageRoute chatSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new ChatsPage()
          );
}

MaterialPageRoute friendSwitch(){
          //login logic goes here. determines if following code is allowed
          return new MaterialPageRoute(
            builder: (context) => new FriendPage()
          );
}
