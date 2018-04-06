import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    FormState nameForm;
    final phoneForm = phoneFormKey.currentState;
    bool phoneVal = phoneForm.validate();

    if(phoneVal){
      phoneForm.save();
      phoneNumber = countryCode + firstPart + secondPart + thirdPart;
      phoneForm.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      user.setPhone = phoneNumber;
    
      if(widget._page == 1 ){
        nameForm = widget._formKey.currentState;
        if(nameForm.validate()){
          nameForm.save();
          widget._showOverlay();
        }
      }
      else{
        widget._showOverlay();
      }
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
      key: phoneFormKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  const Text("Country Code:", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                  new Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0)),
                  new DropdownButton(
                  onChanged: (value) => countryCode = value,
                  items: [
                    const DropdownMenuItem(
                      child: const Text("+1")
                    ),
                  ],
                ),
              ]
            )
          ),
          new Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),
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
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(3)
                  ],
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
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(3)
                  ],
                  focusNode: secondInputNode,
                )
              ),
              new Padding(padding: new EdgeInsets.only(right: 10.0),),
              new Expanded(
                child: new TextFormField(
                  controller: thirdPartNumberControl,
                  decoration: const InputDecoration(hintText: '5555', border: const OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (val) => val.length != 4 ? 'Invalid' : null,
                  onSaved: (val) => thirdPart = val,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(4)
                  ],
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
                  onPressed: () => submitNumber()
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