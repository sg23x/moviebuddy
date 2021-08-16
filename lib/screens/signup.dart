import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'homepage.dart';
import '../services/userManagement.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  String email, name, password;

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
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                    ),
                    onChanged: (value) => name = value,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              RaisedButton(
                onPressed: () async {
                  // print("$email $password");
                  await Firebase.initializeApp();
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((newUser) {
                    UserManagement().storeNewUser(
                      user: newUser,
                      context: context,
                      name: name,
                    );
                  }).catchError((e) {
                    print("signup error $e");
                  });
                },
                child: Text("Signup"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  'Go to login',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
