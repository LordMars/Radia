import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
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
  final formKey = new GlobalKey<FormState>();

  //Should display overlay/verify number
  bool overlay, verify;
  String firstName, lastName;

  /*Shows overlay while waiting for response from
  * cloud function for both sending the verification
  * code and verifying the code the user has input 
  */
  void showOverlay(){
    User.getInstance().setFirstName = firstName;
    User.getInstance().setLastName = lastName;
    setState((){
      overlay = true;
    });

    if(!verify){ 
     User.getInstance().sendSignupCode(scaffoldKey).then((success){
       hideOverlay();
       if(success){
         verify = true;
       }
     })
     .catchError((onError) => verify = false);
    }
    else{
      User.getInstance().verifySignupCode(scaffoldKey).then((success) async{
        hideOverlay();
        if(success){
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("phone", User.getInstance().phone);
          preferences.setString("uid", User.getInstance().uid);
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
    firstName = '';
    lastName = '';
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
              (overlay) ? new Container() : new Form(
                key: formKey,
                child: new Padding(
                  padding: const EdgeInsets.only(top:60.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.topCenter,
                        child: new Text("Radia", style: new TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 30.0),
                          )
                        ),
                      new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
                      new Container(
                        alignment: Alignment.topCenter,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.symmetric(horizontal: 5.0),),
                            new Expanded(
                              child:new TextFormField(
                                decoration: new InputDecoration(hintText: 'John', labelText: "First Name"),
                                keyboardType: TextInputType.text,
                                validator: (val) => (val.length == 0) ? "Invalid" : null,
                                onSaved: (val) => firstName = val,
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(25)
                                ],
                              ),
                            ),
                            new Padding(padding: new EdgeInsets.only(left: 5.0),),
                            new Expanded(
                              child:new TextFormField(
                                decoration: new InputDecoration(hintText: 'Smith', labelText: "Last Name"),
                                keyboardType: TextInputType.text,
                                validator: (val) => (val.length == 0) ? "Invalid" : null,
                                onSaved: (val) => lastName = val,
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(25)
                                ],
                              ),
                            ),
                            new Padding(padding: new EdgeInsets.symmetric(horizontal: 5.0),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (overlay) ? new Container() : ((verify) ? new CodeInput(showOverlay) : new PhoneInput(showOverlay, formKey)),
              (overlay) ? new LoadingOverlay() : new Container(),
            ],
        )
      ),
    );
  }
}
