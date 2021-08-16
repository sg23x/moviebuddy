import 'package:flutter/material.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Soumya!'),
      ),
      body: ListView(
        children: [
          MovieListItem(),
          MovieListItem(),
          MovieListItem(),
        ],
      ),
    );
  }
}
