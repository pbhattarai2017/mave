import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';
import './verification.dart';

class SignUpPage extends StatelessWidget {
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
      body: Container(
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
                  SignUpForm(cardMargin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final cardMargin;
  SignUpForm(this.cardMargin);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
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
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Firstname',
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
                validator: (firstname) {
                  if (firstname.length == 0) {
                    return 'Firstname can\'t be empty';
                  } else {
                    return null;
                  }
                },
              ),
              //PASSWORD FIELD
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                autovalidate: _autovalidate,
                validator: (lastname) {
                  if (lastname.length == 0) {
                    return 'Lastname can\'t be empty';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                autovalidate: _autovalidate,
                validator: (email) {
                  if (email.length == 0) {
                    return 'Email can\'t be empty';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                autovalidate: _autovalidate,
                validator: (password) {
                  if (password.length == 0) {
                    return 'Password can\'t be empty';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: _confirmpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                autovalidate: _autovalidate,
                validator: (confirmpass) {
                  if (confirmpass.length == 0) {
                    return 'Confirm password can\'t be empty';
                  } else if (confirmpass != _passwordController.text) {
                    return 'Passwords don\'t match';
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign in',
                      ),
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VerificationPage(),
                            ),
                          );
                        } else {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
                      },
                      child: Text(
                        'Submit',
                      ),
                    ),
                  ],
                ),
              ),
              ButtonTheme(
                minWidth: 230.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'Social Media Sign Up',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
