import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moviebuddy/adapters/moviesAdapter.dart';
import 'package:moviebuddy/screens/homepage.dart';
import 'package:moviebuddy/screens/login.dart';
import 'package:moviebuddy/services/userManagement.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movies');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: UserManagement().retrieveUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            print("hello ji " + snapshot.data.uid);
            return HomePage(
              user: snapshot.data,
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}
