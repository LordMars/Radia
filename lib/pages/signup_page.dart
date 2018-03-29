import 'package:flutter/material.dart';
import './main_page.dart';
import '../ui/code_input.dart';
import '../ui/phone_input.dart';
import '../ui/loading_overlay.dart';
import '../utils/user.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Navigation Basics',
    home: new SignupPage(),
  ));
}

class SignupPage extends StatefulWidget{

  @override
  State createState() => new SignupPageState();
}

class SignupPageState extends State<SignupPage>{

  //Key giving the Scaffold a unique identifier
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  //Should display overlay/verify number
  bool overlay, verify;

  /*Shows overlay while waiting for response from
  * cloud function for both sending the verification
  * code and verifying the code the user has input 
  */
  void showOverlay(){
    setState((){
      overlay = true;
    });

    if(!verify){ 
     User.getInstance().sendCode(scaffoldKey).then((success){
       hideOverlay();
       if(success){
         verify = true;
       }
     })
     .catchError((onError) => verify = false);
    }
    else{
      User.getInstance().verifyCode(scaffoldKey).then((success){
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
  void initState() {
    super.initState();
    overlay = false;
    verify = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => Navigator.of(context).pushReplacementNamed('/login'),
        child: new Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            title: new Text('Phone SignUp'),
          ),
          body:new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              (overlay) ? new Container() : ((verify) ? new CodeInput(showOverlay) : new PhoneInput(showOverlay)),
              (overlay) ? new LoadingOverlay() : new Container(),
            ],
        )
      ),
    );
  }
}
