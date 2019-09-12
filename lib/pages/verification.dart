import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';
import './home.dart';

class VerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double cardMargin = 30.0;
    if (mediaQueryData.size.shortestSide < 600.0) {
      cardMargin = 30.0;
    } else {
      cardMargin = 250.0;
    }
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Color(0XFFC2216B),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.7], //stack
                      colors: [
                        Color(0XFF00B0E8), //blue
                        Color(0XFFC2216B), //pink
                      ],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      CustomImage('assets/images/mavelogo.png'),
                      VerificationForm(cardMargin),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VerificationForm extends StatefulWidget {
  final cardMargin;
  VerificationForm(this.cardMargin);
  @override
  _VerificationFormState createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final resendCodeSnackBar = SnackBar(
    content: Text('Verification Code has been sent.'),
  );
  final _formKey = GlobalKey<FormState>();
  TextEditingController _verifycodeController = TextEditingController();
  bool _autovalidate = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: widget.cardMargin,
          vertical: 50.0,
        ),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                ),
                child: Text(
                  'Enter 6-digit verification code sent in your email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              TextFormField(
                controller: _verifycodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                    labelText: 'Verification Code',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    )),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                autovalidate: _autovalidate,
                validator: (code) {
                  if (code.length != 6) {
                    return 'Code should be 6 digits.';
                  } else {
                    return null;
                  }
                },
              ),
              //PASSWORD FIELD
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      //yet to be implemented
                      Scaffold.of(context).showSnackBar(resendCodeSnackBar);
                    },
                    child: Text(
                      'Resend code',
                    ),
                    textColor: Colors.white,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomePage()));
                      } else {
                        _autovalidate = true;
                      }
                    },
                    child: Text(
                      'Submit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
