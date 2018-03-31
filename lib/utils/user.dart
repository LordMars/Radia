import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class User{
  static User _user;
  String _phone;
  String _status;
  String _confirmationCode;
  String _firstName;
  String _lastName;
  String _uid;

  User(){
   this._phone = '';
   this._status = '';
   this._confirmationCode = '';
   this._firstName = '';
   this._lastName = '';
   this._uid = '';
  }


  static User getInstance(){
    if(_user == null){
      _user = new User();
    }
    return _user;
  }


  String get phone => this._phone;
  set setPhone(phone){ this._phone = phone;}

  String get status => this._status;
  set setStatus(status){ this._status = status;}

  String get firstName => this._firstName;
  set setFirstName(firstName){ this._firstName = firstName;}

  String get lastName => this._lastName;
  set setLastName(lastName){ this._lastName = lastName;}

  set setCode(code){ this._confirmationCode = code;}

  String get uid => this._uid;
  set setUid(uid) => this._uid = uid;

 /* Attempts to post user's phone number to
  * cloud function. Receives a success or
  * error as a return
  */
 Future<bool> sendSignupCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/signupConfirmationCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {"phone": this._phone, "firstName":this._firstName, "lastName":this._lastName})
	  .then((response){
        if(response.statusCode == 200){
		  this._uid = json.decode(response.body)['uid'];
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

  Future<bool> sendLoginCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/loginConfirmationCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {"phone": this._phone, "uid": this._uid})
	  .then((response){
        if(response.statusCode == 200){
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

  Future<bool> verifySignupCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/signupVerifyUserCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {
        "radiaCode":this._confirmationCode,
        "uid": this._uid,
        "phoneNumber": this._phone
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
          content: new Text('Error Sending Confirmation Code'),
        )
      );
      success = false;
    }
    return success;
  }

Future<bool> verifyLoginCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/loginVerifyUserCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {
        "radiaCode":this._confirmationCode,
        "uid": this._uid,
        "phoneNumber": this._phone
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
          content: new Text('Error Sending Confirmation Code'),
        )
      );
      success = false;
    }
    return success;
  }
}
