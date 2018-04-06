import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<bool> sendSignupCode()async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/signupConfirmationCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {"phone": User.getInstance().phone, 
      "firstName":User.getInstance().firstName, 
      "lastName":User.getInstance().lastName})
	  .then((response){
        if(response.statusCode == 200){
		  User.getInstance().setUid = json.decode(response.body)['uid'];
          result = 'Sending Confirmation Text';
          success = true;
        }
        else{
          result = 'Error sending phone number';
          success = false;
        }
        scaffoldKey.currentState.showSnackBar(  //Alert user text has been sent
        new SnackBar(
            content: new Text(result),
          )
        );

      });
    }catch(exception){
        scaffoldKey.currentState.showSnackBar(  //Alert user an error occured sending text
        new SnackBar(
          content: new Text('Error Sending Phone Number'),
        )
      );
      success = false;
    }

    return success;
  }

  Future<bool> verifySignupCode()async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/signupVerifyUserCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {
        "radiaCode":User.getInstance().code,
        "uid": User.getInstance().uid,
        "phoneNumber": User.getInstance().phone
        }).then((response){
        
        if(response.statusCode == 200){
          result = 'Code Confirmed!';
          success = true;
        }
        else{
          result = 'Invalid Confirmation Code';
          success = false;
        }
        scaffoldKey.currentState.showSnackBar(  //Alert user text has been sent
        new SnackBar(
            content: new Text(result),
          )
        );

      });
    }catch(exception){
        scaffoldKey.currentState.showSnackBar(  //Alert user an error occured sending text
        new SnackBar(
          content: const Text('Error Sending Confirmation Code'),
        )
      );
      success = false;
    }
    return success;
  }

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
     sendSignupCode().then((success){
       hideOverlay();
       if(success){
         verify = true;
       }
     })
     .catchError((onError) => verify = false);
    }
    else{
      verifySignupCode().then((success) async{
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
                        child: const Text("Radia", style: const TextStyle(
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
              (overlay) ? new Container() : ((verify) ? new CodeInput(showOverlay) : new PhoneInput(showOverlay, formKey, 1)),
              (overlay) ? new LoadingOverlay() : new Container(),
            ],
        )
      ),
    );
  }
}
