import 'package:flutter/material.dart';
import './main_page.dart';


//will contain a list of chats
class ChatPage extends StatefulWidget{
  @override
  ChatPageState createState() => new ChatPageState();
}

class Chat extends StatefulWidget{
  String text;
  Chat(String text){
    this.text = text;
  }
  @override
  ChatState createState() => new ChatState(text);
}

class ChatState extends State<Chat>{
  String text;
  ChatState(String text){
    this.text = text;
  }

  @override
  Widget build(BuildContext context){
    return new Material(
      child: new Text(text)
    );
  }
}

void newChatCreate(List<Chat> chats, String text){
    chats.add(new Chat(text));
}

//will update that list of chats when new ones are sent
class ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

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