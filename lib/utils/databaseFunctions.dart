import 'dart:async';
import 'dart:io' show Platform;
import 'Message.dart';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:uuid/uuid.dart';

var uuid = new Uuid();  // variable holds uuid instance

//final FirebaseApp app = new FirebaseApp(
//  name: 'db2',
//  options: Platform.isIOS
//      ? const FirebaseOptions(
//    // TODO: fix ios settings
//    googleAppID: '1:21220570862:android:21efafaf229a3e37',
//    gcmSenderID: '297855924061',
//    databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//  )
//      : const FirebaseOptions(
//    googleAppID: '1:21220570862:android:21efafaf229a3e37',
//    apiKey: 'AIzaSyALkwB8OmzKUIy7EMfSLZCzP5u2Te3xgZM',
//    databaseURL: 'https://radia-personal-build.firebaseio.com',
//  ),
//);

void main() {
  Message message = new Message("84343-userid-what-nr", "1452-chat-ID", MessageType.text, "God is good!", new DateTime.now());
  createNewMessage(message);
}

void test() {
  Message message = new Message("84343-userid-what-nr", "1452-chat-ID", MessageType.text, "God is good!", new DateTime.now());
  createNewMessage(message);
  print(getMessageByChatID("1452-chat-ID").length);
}

int messageTypeToInt(MessageType messageType) {
  return (messageType == MessageType.text) ? 1 : 2;
}

MessageType intToMessageType(int messageTypeInt) {
  return (messageTypeInt == 1) ? MessageType.text : MessageType.media;
}

// Create a new message
bool createNewMessage(Message message) {
  message.messageID = uuid.v4(); // generate a new random message id
  final messagesRef = FirebaseDatabase.instance.reference().child('messages/' + message.messageID);
  messagesRef.set({
    'userID': message.userID,
    'chatID': message.chatID,
    'messageType': messageTypeToInt(message.messageType),
    'messageContent': message.messageContent,
    'createdTimestamp': message.createdTimestamp.toString(),
  });
  // TODO: catch firebase error
  return true;
}


// Get a list of messages belonging to a chat ID
List<Message> getMessageByChatID(String chatID) {
  var messagesRef = FirebaseDatabase.instance.reference().child('messages')
      .orderByChild('chatID').equalTo(chatID);
  List<Message> messages = new List<Message>();
  messagesRef.once().then((DataSnapshot snapshot) {
    print(snapshot.value);
    if (snapshot.value == null) { return new List<Message>();}
    //Map data = JSON.decode(snapshot.value); // parse snapshot
    //print('Connected to second database and read ${data}');
    //var messageTest = snapshot.value.map((message) => new Message(message["userID"], message["chatID"], intToMessageType(message["messageType"]), message["messageContent"], message["createTimestamp"]));
    //print(messageTest);
    // Get the messageID
    //Map<String, dynamic> messageMap = JSON.decode(snapshot.value);
//    var key = snapshot.key;
//    // Get the message object
//    var data = snapshot.value;
//    Message message = new Message(data['userID'], data['chatID'],
//    intToMessageType(data['messageType']), data['messageContent'],
//    data['createdTimestamp']);
//    message.messageID = key;
    //messages.add(message);
    //print(messageMap);
  });
  return new List<Message>();
}
