import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './main_page.dart';
import '../utils/user.dart';
import '../ui/loading_overlay.dart';
import '../ui/code_input.dart';
import '../ui/phone_input.dart';

class LoginPage extends StatefulWidget{
  
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{

  String countryCode, phoneNumber;
  bool overlay, verify;
  
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<String> findSavedPhone() async{
    String uid = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid');
    return uid;
  }

  void showOverlay(){
    setState((){
      overlay = true;
    });

    if(!verify){ 
     User.getInstance().sendLoginCode(scaffoldKey).then((success){
       hideOverlay();
       if(success){
         verify = true;
       }
     })
     .catchError((onError) => verify = false);
    }
    else{
      User.getInstance().verifyLoginCode(scaffoldKey).then((success) async{
        hideOverlay();
        if(success){
          Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new HomePage()), 
            (Route route) => route == null);
        }
      });
    }
  }

  //Hides the overlay
  void hideOverlay(){
    setState((){
      overlay = false;
    });

  }


  @override
  void initState(){
    super.initState();
    countryCode = "+1";
    phoneNumber = "";
    overlay = false;
    verify = false;
    findSavedPhone().then((uid){
      if (uid != null && uid != ''){
        User.getInstance().setUid = uid;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        key: scaffoldKey,
        body: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[(overlay) ? new Container() : new Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: new Container(
                  child: new Text("Radia", style: new TextStyle(
                    color: Colors.blue, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 30.0),
                    ),
                ),
              ),
              new Padding(padding: new EdgeInsets.only(bottom: 20.0),),
            (overlay) ? new Container() : ((verify) ? new CodeInput(showOverlay) : new PhoneInput(showOverlay, null, 0)),
            ]),
            (overlay) ? new LoadingOverlay() : new Container()
          ],
        ),
      ),
    );
  }
}