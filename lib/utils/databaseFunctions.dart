import 'dart:async';
import 'dart:io' show Platform;
import 'Message.dart';

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

final FirebaseDatabase database = new FirebaseDatabase();


void main() {
  Message message = new Message("84343-userid-what-nr", MessageType.text, "God is good!", new DateTime.now());
  createNewMessage(message);
}

void test() {
  Message message = new Message("84343-userid-what-nr", MessageType.text, "God is good!", new DateTime.now());
  createNewMessage(message);
}

int messageTypeToInt(MessageType messageType) {
  return (messageType == MessageType.text) ? 1 : 0;
}

// Create a new message
bool createNewMessage(Message message) {
  message.messageID = uuid.v4(); // generate a new random message id
  //var messageRef = database.reference().child('messages');
  final messageRef = FirebaseDatabase.instance.reference().child('messages/' + message.messageID);
  messageRef.set({
    'userID': message.userID,
    'messageType': messageTypeToInt(message.messageType),
    'messageContent': message.messageContent,
    'createdTimestamp': message.createdTimestamp.toString(),
  });
  // TODO: catch firebase error
  return true;
}

// Get a list of messages

