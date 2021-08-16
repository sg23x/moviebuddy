import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moviebuddy/screens/homepage.dart';

class UserManagement {
  Future<User> retrieveUser() async {
    await Firebase.initializeApp();
    return FirebaseAuth.instance.currentUser;
  }

  storeNewUser({
    @required user,
    @required context,
    @required name,
  }) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('users').doc(user.user.uid).set({
      'email': user.user.email,
      'uid': user.user.uid,
      'name': name,
    }).then(
      (v) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
              user: user.user,
            ),
          ),
        );
      },
    );
  }
}
