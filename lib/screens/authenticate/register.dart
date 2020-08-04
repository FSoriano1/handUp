import 'package:flutter/material.dart';
import 'package:test1/models/user.dart';
import 'package:test1/services/auth.dart';
import 'package:test1/services/database.dart';
import 'package:test1/shared/constants.dart';
import 'package:test1/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool step2 = false;

  String username = '';
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.red[100],
            appBar: AppBar(
                backgroundColor: Colors.red[400],
                elevation: 0.0,
                title: Text('Sign Up'),
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Sign Up'),
                      onPressed: () {
                        widget.toggleView();
                      })
                ]),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'email'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'username'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter a username!' : null,
                            onChanged: (val) {
                              setState(() => username = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'password'),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Password must be at least 6 chars long!'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            }),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.blue[300],
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result = await _auth
                                    .registerEmailPassword(email, password);

                                if (result == null) {
                                  setState(() {
                                    error = 'Email is not valid!';
                                    loading = false;
                                  });
                                } else {
                                  final DatabaseService ds = DatabaseService();
                                  User user = result;
                                  await ds.addUsername(username, user.uid);
                                }
                              }
                            }),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ))));
  }
}
