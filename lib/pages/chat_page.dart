import 'package:flutter/material.dart';
import './main_page.dart';

//will contain a list of chats
class Page extends StatefulWidget{
  Msg message;

  Page([Msg message]){
    this.message = message;
  }

  @override
  PageState createState() => message != null ? new PageState(message) : new PageState();
}

//will update that list of chats when new ones are sent
class PageState extends State<Page> with TickerProviderStateMixin{

  //List of chats, only exists while this page survives currently

  final List<Posts> posts = <Posts>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  PageState([Msg message]){
    message != null ? posts.add(message) : null;
  }

  void onPressed(){
    setState((){
      newPostsCreate(posts, _textController.text);
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
                    itemBuilder: (_, int index) => posts[index],
                    itemCount: posts.length,
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

abstract class Posts extends StatelessWidget{}

class Chat extends Posts{
  String text;
  Chat(String text){
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

class Msg extends Posts{
  String text;
  Msg(String text){
    this.text = text;
  }

  @override
  Widget build(BuildContext context){
    return new Card(
      child: new Column(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              border: new Border.all(
                color: Colors.orange,
                width: 8.0,
              )
            )
            ),
          new Text(text),
        ]
      )
    );
  }
}

//determines types of items in list and what items to add to list
//will be modified to integrate with a server
void newPostsCreate(List<Posts> posts, String text){
  if(posts.isEmpty){
    posts.add(new Chat(text));
  }
  else{
    posts[0] is Chat ? posts.add(new Chat(text)) : posts.add(new Msg(text));
  }
}

MaterialPageRoute singleChatSwitch(Msg message){
          return new MaterialPageRoute(
            builder: (context) => new Page(message)
          );
}