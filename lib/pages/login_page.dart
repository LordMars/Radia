import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './main_page.dart';
import '../ui/code_input.dart';
import '../ui/loading_overlay.dart';
import '../ui/phone_input.dart';
import '../utils/user.dart';

class LoginPage extends StatefulWidget {
  final String loginConfirmationURL =
      "https://us-central1-radia-personal-build.cloudfunctions.net/loginConfirmationCode";

  final String loginVerificationURL =
      "https://us-central1-radia-personal-build.cloudfunctions.net/loginVerifyUserCode";

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String countryCode, phoneNumber;
  bool overlay, verify;

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<String> findSavedPhone() async {
    String uid = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid');
    return uid;
  }

/* Attempts to post user's phone number to
  * cloud function. Receives a success or
  * error as a return
  */
  Future<bool> sendLoginCode() async {
    var uri = Uri.parse(widget.loginConfirmationURL);
    String result;
    bool success = false;

    try {
      await http.post(uri, body: {
        "phone": User.getInstance().phone,
        "uid": User.getInstance().uid
      }).then((response) {
        if (response.statusCode == 200) {
          result = 'Sending Confirmation Text';
          success = true;
        } else {
          result = 'Error sending phone number';
          success = false;
        }
        scaffoldKey.currentState.showSnackBar(//Alert user text has been sent
            new SnackBar(
          content: new Text(result),
        ));
      });
    } catch (exception) {
      scaffoldKey.currentState
          .showSnackBar(//Alert user an error occured sending text
              new SnackBar(
        content: const Text('Error Sending Phone Number'),
      ));
      success = false;
    }
    return success;
  }

  Future<bool> verifyLoginCode() async {
    var uri = Uri.parse(widget.loginVerificationURL);
    String result;
    bool success = false;

    try {
      await http.post(uri, body: {
        "radiaCode": User.getInstance().code,
        "uid": User.getInstance().uid,
        "phoneNumber": User.getInstance().phone
      }).then((response) {
        if (response.statusCode == 200) {
          result = 'Code Confirmed!';
          success = true;
        } else {
          result = 'Invalid Confirmation Code';
          success = false;
        }
        scaffoldKey.currentState.showSnackBar(//Alert user text has been sent
            new SnackBar(
          content: new Text(result),
        ));
      });
    } catch (exception) {
      scaffoldKey.currentState
          .showSnackBar(//Alert user an error occured sending text
              new SnackBar(
        content: const Text('Error Sending Confirmation Code'),
      ));
      success = false;
    }
    return success;
  }

  void showOverlay() {
    setState(() {
      overlay = true;
    });

    if (!verify) {
      sendLoginCode().then((success) {
        hideOverlay();
        if (success) {
          verify = true;
        }
      }).catchError((onError) => verify = false);
    } else {
      verifyLoginCode().then((success) async {
        hideOverlay();
        if (success) {
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new HomePage()),
              (Route route) => route == null);
        }
      });
    }
  }

  //Hides the overlay
  void hideOverlay() {
    setState(() {
      overlay = false;
    });
  }

  @override
  void initState() {
    super.initState();
    countryCode = "+1";
    phoneNumber = "";
    overlay = false;
    verify = false;
    findSavedPhone().then((uid) {
      if (uid != null && uid != '') {
        User.getInstance().setUid = uid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        key: scaffoldKey,
        body: new Stack(
          children: <Widget>[
            new Column(children: <Widget>[
              (overlay)
                  ? new Container()
                  : new Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: new Container(
                        child: const Text(
                          "Radia",
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0),
                        ),
                      ),
                    ),
              new Padding(
                padding: new EdgeInsets.only(bottom: 20.0),
              ),
              (overlay)
                  ? new Container()
                  : ((verify)
                      ? new CodeInput(showOverlay)
                      : new PhoneInput(showOverlay, null, 0)),
            ]),
            (overlay) ? new LoadingOverlay() : new Container()
          ],
        ),
      ),
    );
  }
}
