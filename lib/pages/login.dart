import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';
import './signup.dart';
import './home.dart';

class LoginPage extends StatelessWidget {
  // final TextEditingController usernameTextController = TextEditingController();
  // final TextEditingController passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double cardMargin = 30.0;
    if (mediaQueryData.size.shortestSide < 600.0) {
      cardMargin = 30.0;
    } else {
      cardMargin = 250.0;
    }
    // if (mediaQueryData.orientation == Orientation.portrait) {
    //   cardMargin = 300.0;
    // } else {
    //   cardMargin = mediaQueryData.size.height / 5;
    // }
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
                  LoginForm(cardMargin),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final cardMargin;
  LoginForm(this.cardMargin);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
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
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Username',
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
                validator: (username) {
                  if (username.length == 0) {
                    return 'Username can\'t be empty';
                  } else {
                    return null;
                  }
                },
              ),
              //PASSWORD FIELD
              TextFormField(
                obscureText: true,
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
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                      ),
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return HomePage();
                              },
                            ),
                          );
                        } else {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
                      },
                      child: Text(
                        'Sign in',
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
                      'Social Media Sign in',
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Don\'t have an account yet ?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text('Sign Up'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
