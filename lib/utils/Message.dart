enum MessageType {
  text, message
}
class Message {
  String _messageID;
  String _userID;
  MessageType _messageType;
  String _messageContent;

  String get messageID => _messageID;

  set messageID(String value) {
    _messageID = value;
  }

  DateTime _createdTimestamp;

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  MessageType get messageType => _messageType;

  set messageType(MessageType value) {
    _messageType = value;
  }

  String get messageContent => _messageContent;

  set messageContent(String value) {
    _messageContent = value;
  }

  DateTime get createdTimestamp => _createdTimestamp;

  set createdTimestamp(DateTime value) {
    _createdTimestamp = value;
  }

  @override
  String toString() {
    return 'Message{_messageID: $_messageID, _userID: $_userID, _messageType: $_messageType, _messageContent: $_messageContent, _createdTimestamp: $_createdTimestamp}';
  }
}