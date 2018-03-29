import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/user.dart';

class PhoneInput extends StatefulWidget{

  final VoidCallback _showOverlay;
  PhoneInput(this._showOverlay);

  State createState() => new PhoneInputState();
}

class PhoneInputState extends State<PhoneInput>{

  //Strings to be combined into final phonenumber
  String phoneNumber, countryCode, firstPart, secondPart, thirdPart;
  String firstName, lastName, password;

  //Key giving the Form a unique identifier
  final formKey = new GlobalKey<FormState>();

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

  bool hidePassword = true;
  bool hidePasswordConfirmation = true;

  //Validates each field in the form
  void submitNumber(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      FocusScope.of(context).requestFocus(new FocusNode()); 

      phoneNumber = countryCode + firstPart + secondPart + thirdPart;
      User.getInstance().setPhone = phoneNumber;
	    User.getInstance().setFirstName = firstName;
      User.getInstance().setLastName = lastName;
      User.getInstance().setPassword = password;
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
	  firstName = '';
	  lastName = '';
    password = '';
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
      key: formKey,
      child: new Column(
        children: <Widget>[
          new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
		  new Container(
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
		      new Padding(padding: new EdgeInsets.symmetric(vertical: 5.0),),
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
          new Container(
              width: MediaQuery.of(context).size.width * 0.80,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          hintText: 'abc123', 
                          labelText: 'Password',
                          helperText: "At least 8 numbers, letters, or other characters", 
                          ),
                        keyboardType: TextInputType.text,
                        validator: (val) => (val.length != 8 || val.length > 25) ? 'Too Short!' : null,
                        obscureText: hidePassword,
                        onSaved: (val) => password = val,
                    ),
                  ),
                  new IconButton(
                    alignment: Alignment.centerRight,
                    icon: new Icon(Icons.remove_red_eye),
                    onPressed: (){
                      setState((){
                        hidePassword = !hidePassword;
                      });
                    }),
                ],
              ),
          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
          new Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          hintText: 'abc123', 
                          labelText: 'Confirm Password',
                          helperText: "At least 8 numbers, letters, or other characters", 
                          ),
                        keyboardType: TextInputType.text,
                        validator: (val){ (val != password) ? 'Does Not Match!' : null;},
                        obscureText: hidePasswordConfirmation,
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.remove_red_eye),
                    onPressed: (){
                      setState((){
                        hidePasswordConfirmation = !hidePasswordConfirmation;
                      });
                    }),
                ],
              ),
          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
          new Container(
            alignment: Alignment.center,
            child:new FlatButton(
            color: Colors.blueAccent,
            child: const Text("Submit", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            onPressed: () => submitNumber(),
          )
        ),
        ]
      )
    );
  }
}