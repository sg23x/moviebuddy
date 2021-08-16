import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  MovieListItem({
    this.movieName,
    this.movieDirector,
    this.deleteMovieItem,
    this.editMovieItem,
  });
  String movieName;
  String movieDirector;
  VoidCallback deleteMovieItem;
  VoidCallback editMovieItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      margin: EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
          ),
          Column(
            children: [
              Text('$movieName'),
              Text('by $movieDirector'),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editMovieItem,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteMovieItem,
          ),
        ],
      ),
    );
  }
}
