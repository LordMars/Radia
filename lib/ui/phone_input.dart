import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/main_page.dart';
import '../utils/user.dart';

class PhoneInput extends StatefulWidget{

  final VoidCallback _showOverlay;
  final _formKey;
  final _page;
  PhoneInput(this._showOverlay, this._formKey, this._page);

  State createState() => new PhoneInputState();
}

class PhoneInputState extends State<PhoneInput>{

  //Strings to be combined into final phonenumber
  String phoneNumber, countryCode, firstPart, secondPart, thirdPart;
  String firstName, lastName;

  //Key giving the Form a unique identifier
  final phoneFormKey = new GlobalKey<FormState>();

  //User Instance
  final User user = User.getInstance();

   /* Allows for keyboard focus to be programmatically switched
   * to a specific widget
   */
  final FocusNode firstInputNode = new FocusNode();
  final FocusNode secondInputNode = new FocusNode();
  final FocusNode thirdInputNode = new FocusNode();

  //Controllers for each part of the phone number
  TextEditingController firstPartNumberControl = new TextEditingController();
  TextEditingController secondPartNumberControl = new TextEditingController();
  TextEditingController thirdPartNumberControl = new TextEditingController();

  //Validates each field in the form
  void submitNumber(){
    bool nameVal = true;
    FormState nameForm;
    if(widget._page == 0){
      nameForm = widget._formKey.currentState;
      nameVal = nameForm.validate();
    }
    final phoneForm = phoneFormKey.currentState;
    bool phoneVal = phoneForm.validate();

    if(nameVal && phoneVal){
      (widget._formKey != null) ? nameForm.save() : null;
      phoneForm.save();
      FocusScope.of(context).requestFocus(new FocusNode()); 

      phoneNumber = countryCode + firstPart + secondPart + thirdPart;
      User.getInstance().setPhone = phoneNumber;
      widget._showOverlay();
    }
  }


  @override
  void initState(){
    super.initState();
    countryCode = '+1';
    firstPart = '';
    secondPart = '';
    thirdPart = '';
    firstPartNumberControl.addListener((){
      if(firstPartNumberControl.text.length == 3){ FocusScope.of(context).requestFocus(secondInputNode);}
    });
    secondPartNumberControl.addListener((){
      if(secondPartNumberControl.text.length == 3){ FocusScope.of(context).requestFocus(thirdInputNode);}
    });
  }

  //Remove controllers when state is destroyed
  @override
  void dispose(){
    super.dispose();
    firstPartNumberControl.dispose();
    secondPartNumberControl.dispose();
    thirdPartNumberControl.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new Form(
      key: (widget._page == 0) ? widget._formKey:phoneFormKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  new Text("Country Code:", style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  new Padding(padding: new EdgeInsets.symmetric(horizontal: 5.0)),
                  new DropdownButton(
                  onChanged: (value) => countryCode = value,
                  items: [
                    new DropdownMenuItem(
                      child: new Text("+1")
                    ),
                  ],
                ),
              ]
            )
          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 5.0),),
          new Row(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.only(right: 5.0),),
              new Expanded(
                child: new TextFormField(
                  controller: firstPartNumberControl,
                  decoration: new InputDecoration(hintText: '555', border: new OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val.length != 3 ? 'Invalid' : null,
                  onSaved: (val) => firstPart = val,
                  focusNode: firstInputNode,
                )
              ),
              new Padding(padding: new EdgeInsets.only(right: 10.0),),
              new Expanded(
                child: new TextFormField(
                  controller: secondPartNumberControl,
                  decoration: new InputDecoration(hintText: '555', border: new OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val.length != 3 ? 'Invalid' : null,
                  onSaved: (val) => secondPart = val,
                  focusNode: secondInputNode,
                )
              ),
              new Padding(padding: new EdgeInsets.only(right: 10.0),),
              new Expanded(
                child: new TextFormField(
                  controller: thirdPartNumberControl,
                  decoration: new InputDecoration(hintText: '5555', border: new OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val.length != 4 ? 'Invalid' : null,
                  onSaved: (val) => thirdPart = val,
                  focusNode: thirdInputNode,
                )
              ),
              new Padding(padding: new EdgeInsets.only(right: 10.0),),
            ],
          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
          (widget._page == 1) ? new Container(
            alignment: Alignment.center,
            child:new FlatButton(
            color: Colors.blueAccent,
            child: const Text("Submit", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onPressed: () => submitNumber(),
          )
        ) : new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton.icon(
                  color: Colors.blue,
                  label: const Text("Login", style: const TextStyle(color: Colors.white),),
                  icon: const Icon(Icons.lock_open, color: Colors.white,),
                  onPressed: () async{
                    if(widget._formKey.currentState.validate()){
                      widget._formKey.currentState.save();
                      FocusScope.of(context).requestFocus(new FocusNode()); 

                      phoneNumber = countryCode + firstPart + secondPart + thirdPart;
                      User.getInstance().setPhone = phoneNumber;
                      widget._showOverlay();
                    }
                  }
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 15.0),),
                new FlatButton.icon(
                  color: Colors.blue,
                  label: const Text("SignUp", style: const TextStyle(color: Colors.white),),
                  icon: const Icon(Icons.person_outline, color: Colors.white,),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                ),
              ],
            ),
        ]
      )
    );
  }
}