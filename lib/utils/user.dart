class User{
  static User _user;
  String _phone;
  String _status;
  String _confirmationCode;
  String _firstName;
  String _lastName;
  String _uid;

  User(){
   this._phone = '';
   this._status = '';
   this._confirmationCode = '';
   this._firstName = '';
   this._lastName = '';
   this._uid = '';
  }


  static User getInstance(){
    if(_user == null){
      _user = new User();
    }
    return _user;
  }


  String get phone => this._phone;
  set setPhone(phone){ this._phone = phone;}

  String get status => this._status;
  set setStatus(status){ this._status = status;}

  String get firstName => this._firstName;
  set setFirstName(firstName){ this._firstName = firstName;}

  String get lastName => this._lastName;
  set setLastName(lastName){ this._lastName = lastName;}

  String get code => this._confirmationCode;
  set setCode(code){ this._confirmationCode = code;}

  String get uid => this._uid;
  set setUid(uid) => this._uid = uid;

}
