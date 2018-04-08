import 'package:flutter/material.dart';
import './main_page.dart';

class Msg extends StatelessWidget{
  String text;
  Msg(String text){
    this.text = text;
  }

  @override
  Widget build(BuildContext context){
    return new Card(
      child: new Text(text),
      );
  }
}

void newMsgCreate(List<Msg> msgs, String text){
    msgs.add(new Msg(text));
}

class SingleChatPage extends StatefulWidget{
  Msg message;
  SingleChatPage(Msg message){
    this.message = message;
  }
  @override
  SingleChatPageState createState() => new SingleChatPageState(message);
}

class SingleChatPageState extends State<SingleChatPage>{
  final List<Msg> msgs = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  SingleChatPageState(Msg message){
    this.msgs.add(message);
  }

  void onPressed(){
    setState((){
      newMsgCreate(msgs, _textController.text);
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chats"),
        backgroundColor: Colors.deepOrange,
      ),
      body: new Container(
        child:
            new Column(
              children: <Widget>[
                new Flexible(
                  child: new ListView.builder(
                    itemBuilder: (_, int index) => msgs[index],
                    itemCount: msgs.length,
                    padding: new EdgeInsets.all(6.0),
                    )
                ),
                new Divider(height: 1.0),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _textController,
                          onChanged: (String txt){
                            setState((){
                              _isWriting = txt.length > 0;
                            });
                          },
                          decoration: new InputDecoration.collapsed(hintText: "Type here"),
                        )
                      ),
                      new RaisedButton(
                        child: new Text("Add Chat"),
                        onPressed: onPressed,
                      ),
                    ]
                  ),
                ),
              ]
          )
        ),
    );
  }
}

//will contain a list of chats
class ChatsPage extends StatefulWidget{
  @override
  ChatsPageState createState() => new ChatsPageState();
}

//will update that list of chats when new ones are sent
class ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin{

  //List of chats, only exists while this page survives currently
  final List<Chat> chats = <Chat>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  void onPressed(){
    setState((){
      newChatCreate(chats, _textController.text);
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chats"),
        backgroundColor: Colors.deepOrange,
      ),
      body: new Container(
        child:
            new Column(
              children: <Widget>[
                new Flexible(
                  child: new ListView.builder(
                    itemBuilder: (_, int index) => chats[index],
                    itemCount: chats.length,
                    padding: new EdgeInsets.all(6.0),
                    )
                ),
                new Divider(height: 1.0),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                          controller: _textController,
                          onChanged: (String txt){
                            setState((){
                              _isWriting = txt.length > 0;
                            });
                          },
                          decoration: new InputDecoration.collapsed(hintText: "Type here"),
                        )
                      ),
                      new RaisedButton(
                        child: new Text("Add Chat"),
                        onPressed: onPressed,
                      ),
                    ]
                  ),
                ),
              ]
          )
        ),
    );
  }
}

class Chat extends StatefulWidget{
  String text;
  Chat(String text){
    this.text = text;
  }
  @override
  ChatState createState() => new ChatState(text);
}


void newChatCreate(List<Chat> chats, String text){
    chats.add(new Chat(text));
}

class ChatState extends State<Chat>{
  String text;
  ChatState(String text){
    this.text = text;
  }

  @override
  Widget build(BuildContext context){
    return new Material(
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Colors.red,
                  width: 8.0,
                ),
                ),
              ),
            new Text(text),
            new FlatButton(
              child: new Text("Reply"),
              onPressed: (){
                Navigator.push(
                  context,
                  singleChatSwitch(new Msg(text)),
                );
              }
            )
          ]
        )
      )
      );
  }
}

MaterialPageRoute singleChatSwitch(Msg message){
          return new MaterialPageRoute(
            builder: (context) => new SingleChatPage(message)
          );
}


