import 'dart:io';

import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  MovieListItem({
    this.movieName,
    this.movieDirector,
    // this.imageFile,
    this.deleteMovieItem,
    this.editMovieItem,
  });
  String movieName;
  String movieDirector;
  // File imageFile;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Image.file(imageFile),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
