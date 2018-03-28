import 'package:flutter/material.dart';
import './landing_page.dart';
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
       if(success){
         hideOverlay();
         verify = true;
       }
     })
     .catchError((onError) => verify = false);
    }
    else{
      User.getInstance().verifyCode(scaffoldKey).then((success){
        if(success){
          hideOverlay();
          Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new LandingPage()), 
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
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Phone SignUp'),
      ),
      body:new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          (overlay) ? new LoadingOverlay() : new Container(),
          (verify) ? new CodeInput(showOverlay) : new PhoneInput(showOverlay),
        ],
      )
    );
  }
}
