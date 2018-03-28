enum MessageType {
  text, media
}
class Message {
  String _messageID;  // unique identification for message
  String _userID;     // ID of user who created message
  String _chatID;
  // Chat ID of chat message is in
  MessageType _messageType;   // message type enum - text or media
  String _messageContent; // message content
  DateTime _createdTimestamp;

  /** Constructor **/
  Message(this._userID, this._chatID, this._messageType, this._messageContent, this._createdTimestamp);

  /** Setters **/
  set messageID(String value) {
    _messageID = value;
  }

  set userID(String value) {
    _userID = value;
  }

  set chatID(String value) {
    _chatID = value;
  }

  set messageType(MessageType value) {
    _messageType = value;
  }

  set messageContent(String value) {
    _messageContent = value;
  }

  set createdTimestamp(DateTime value) {
    _createdTimestamp = value;
  }

  /** Getters **/
  String get messageID => _messageID;
  String get userID => _userID;
  String get chatID => _chatID;
  MessageType get messageType => _messageType;
  String get messageContent => _messageContent;
  DateTime get createdTimestamp => _createdTimestamp;

  @override
  String toString() {
    return 'Message{_messageID: $_messageID, _userID: $_userID, _messageType: $_messageType, _messageContent: $_messageContent, _createdTimestamp: $_createdTimestamp}';
  }
}