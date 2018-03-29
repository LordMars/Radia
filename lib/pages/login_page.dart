import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import './main_page.dart';

class LoginPage extends StatefulWidget{
  
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{

  String countryCode;
  String phoneNumber;
  String password;
  String savedNumber;
  bool hidePassword;

  final phoneNumberController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  void initState(){
    countryCode = "+1";
    phoneNumber = "";
    password = "";
    hidePassword = true;
   /*phoneNumberController.addListener((){
      phoneNumberController.value.t
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Material(
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: new Text("Radia", style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30.0),),
            ),
            new Container(
                child: new DropdownButton(
                  items: <DropdownMenuItem>[
                    new DropdownMenuItem(
                      child: new Text("+1"),
                    )
                  ], 
                  onChanged: (value) => countryCode = value,
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child:new TextField(
                controller: phoneNumberController,
                decoration: new InputDecoration(
                  labelText: "Phone Number",
                  hintText: "5555555555"
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
            new Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                        controller: passwordController,
                        decoration: new InputDecoration( 
                          labelText: 'Password',
                          ),
                        keyboardType: TextInputType.text,
                        obscureText: hidePassword,
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.remove_red_eye),
                    onPressed: (){
                      setState((){
                        hidePassword = !hidePassword;
                      });
                    }),
                ],
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 20.0),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton.icon(
                  color: Colors.blue,
                  label: const Text("Login", style: const TextStyle(color: Colors.white),),
                  icon: const Icon(Icons.lock_open, color: Colors.white,),
                  onPressed: () async => Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(builder: (context) => new HomePage()), (Route route) => route == null),
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 15.0),),
                new FlatButton.icon(
                  color: Colors.blue,
                  label: const Text("SignUp", style: const TextStyle(color: Colors.white),),
                  icon: const Icon(Icons.person_outline, color: Colors.white,),
                  onPressed: () async => Navigator.of(context).pushReplacementNamed('/signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}