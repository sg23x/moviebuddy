import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'homepage.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[300],
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.grey,
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                    ),
                    onChanged: (value) => email = value,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.grey,
                  ),
                  child: TextFormField(
                    obscureText: true,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                    ),
                    onChanged: (value) => password = value,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              RaisedButton(
                onPressed: () async {
                  await Firebase.initializeApp();
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  )
                      .then((user) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(
                          user: user.user,
                        ),
                      ),
                    );
                  }).catchError((e) {
                    print("login error $e");
                  });
                },
                child: Text('Login'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignupScreen(),
                    ),
                  );
                },
                child: Text(
                  'Go to signup',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
