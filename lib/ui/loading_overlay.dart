import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black38,
      child: new Center(
        child: new CircularProgressIndicator(
          value: null,
        ),
      ),
    );
  }
}
