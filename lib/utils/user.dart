import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class User{
  static User _user;
  String _phone;
  String _status;
  String _confirmationCode;

  User.privArgs(phone, status){
    this._phone = phone;
    this._status = status;
    this._confirmationCode = '';
  }

  User.privInit(){
   this._phone = '';
   this._status = '';
   this._confirmationCode = '';
  }


  static User getInstance(){
    if(_user == null){
      _user = new User.privInit();
    }
    return _user;
  }

 static User createInstance(String phone, String status){
   if(_user == null){
      _user = new User.privArgs(phone, status);
    }
    return _user;
 }

 String get phone => this._phone;
 set setPhone(phone){ this._phone = phone;}

 String get status => this._status;
 set setStatus(status){ this._status = status;}

 set setCode(code){ this._confirmationCode = code;}

 /* Attempts to post user's phone number to
  * cloud function. Receives a success or
  * error as a return
  */
 Future<bool> sendCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/sendConfirmationCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {"phone": this._phone}).then((response){
        
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

  Future<bool> verifyCode(GlobalKey<ScaffoldState>scaffoldKey)async{
    var uri = Uri.parse('https://us-central1-radia-personal-build.cloudfunctions.net/verifyUserCode');
    String result;
    bool success = false;

    try{
      await http.post(uri, body: {"radiaCode":this._confirmationCode,"phone": this._phone}).then((response){
        
        if(response.statusCode == 200){
          result = 'Code Confirmed!';
          success = true;
        }
        else{
          result = 'Error sending confirmation code';
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
          content: new Text('Error Sending confirmation code'),
        )
      );
      success = false;
    }
    return success;
  }
}