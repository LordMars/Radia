class Pseudoname {
  String _userID;
  String _chatID;
  String _pseudoname;
  DateTime _createdTimestamp;

  Pseudoname(this._userID, this._chatID, this._pseudoname);

  /** Setters **/
  set userID(String value) {
    _userID = value;
  }

  set chatID(String value) {
    _chatID = value;
  }

  set pseudoname(String value) {
    _pseudoname = value;
  }

  set createdTimestamp(DateTime value) {
    _createdTimestamp = value;
  }

  /** Getters **/
  String get userID => _userID;
  String get chatID => _chatID;
  String get pseudoname => _pseudoname;
  DateTime get createdTimestamp => _createdTimestamp;
}