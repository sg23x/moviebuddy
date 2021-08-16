import 'package:flutter/material.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatelessWidget {
  List _movies = [
    {
      'movieName': 'shershaah',
      'movieDirector': 'kia seltos',
    },
    {
      'movieName': 'kbc',
      'movieDirector': 'apple',
    },
    {
      'movieName': '3 idiots',
      'movieDirector': 'virus',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Soumya!'),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, i) {
          return MovieListItem(
            movieName: _movies[i]['movieName'],
            movieDirector: _movies[i]['movieDirector'],
          );
        },
      ),
    );
  }
}
