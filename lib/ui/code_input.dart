import 'package:flutter/material.dart';
import '../utils/user.dart';

class CodeInput extends StatefulWidget{

  final VoidCallback _showOverlay;

  CodeInput(this._showOverlay);
  
  State createState() => new CodeInputState();
}

class CodeInputState extends State<CodeInput>{

  //Controllers for each part of the verification code
  final TextEditingController firstNumController = new TextEditingController();
  final TextEditingController secondNumController = new TextEditingController();
  final TextEditingController thirdNumController = new TextEditingController();
  final TextEditingController fourthNumController = new TextEditingController();
  final TextEditingController fifthNumController = new TextEditingController();
  final TextEditingController sixthNumController = new TextEditingController();

  //Focus nodes for switching between input areas
  final firstNode = new FocusNode();
  final secondNode = new FocusNode();
  final thirdNode = new FocusNode();
  final fourthNode = new FocusNode();
  final fifthNode = new FocusNode();
  final sixthNode = new FocusNode();
 
  //Vars to hold the values of each input area
  String code;
  String firstNum;
  String secondNum;
  String thirdNum;
  String fourthNum;
  String fifthNum;
  String sixthNum;

  //Unique identifier for the form
  final formKey = new GlobalKey<FormState>();

  //Validate code inputs
  void validateCode(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      FocusScope.of(context).requestFocus(new FocusNode());

      code = firstNum + secondNum + thirdNum + fourthNum + fifthNum + sixthNum;
      User.getInstance().setCode = code;
      widget._showOverlay();
    }
  }

  @override
  void initState(){
    super.initState();
    code = '';
    firstNum = '';
    secondNum = '';
    thirdNum = '';
    fourthNum = '';
    fifthNum = '';
    sixthNum = '';
    firstNumController.addListener((){
      if(firstNumController.text.length == 1){FocusScope.of(context).requestFocus(secondNode);}
    });
    secondNumController.addListener((){
      if(secondNumController.text.length == 1){FocusScope.of(context).requestFocus(thirdNode);}
    });
    thirdNumController.addListener((){
      if(thirdNumController.text.length == 1){FocusScope.of(context).requestFocus(fourthNode);}
    });
    fourthNumController.addListener((){
      if(fourthNumController.text.length == 1){FocusScope.of(context).requestFocus(fifthNode);}
    });
    fifthNumController.addListener((){
      if(fifthNumController.text.length == 1){FocusScope.of(context).requestFocus(sixthNode);}
    });
  }

  @override
  Widget build(BuildContext context){
    return new Material(
      color: Colors.white,
      child: new Form(
        key: formKey,
        child: new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
            new Text("Enter Confirmation Code:"),
            new Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),
            new Row(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: firstNumController,
                    focusNode: firstNode,
                    decoration: new InputDecoration(hintText: '1', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => firstNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: secondNumController,
                    focusNode: secondNode,
                    decoration: new InputDecoration(hintText: '2', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => secondNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: thirdNumController,
                    focusNode: thirdNode,
                    decoration: new InputDecoration(hintText: '3', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => thirdNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: fourthNumController,
                    focusNode: fourthNode,
                    decoration: new InputDecoration(hintText: '4', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => fourthNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: fifthNumController,
                    focusNode: fifthNode,
                    decoration: new InputDecoration(hintText: '5', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => fifthNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 3.0),),
                new Expanded(
                  child: new TextFormField(
                    controller: sixthNumController,
                    focusNode: sixthNode,
                    decoration: new InputDecoration(hintText: '6', border: new OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val.length != 1 || int.parse(val.substring(0, 1), onError:(e) => null) == null) ? "Invalid" : null,
                    onSaved: (val) => sixthNum = val,
                  )
                ),
                new Padding(padding: new EdgeInsets.only(right: 3.0),),
              ],
            ),
            new Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            new FlatButton.icon(
              color: Colors.blueAccent,
              icon: const Icon(Icons.done, color: Colors.white),
              label: const Text("Submit", style: const TextStyle(color: Colors.white),),
              onPressed: () => validateCode(),
            )
          ],
        )
      ),
    );
  }
}