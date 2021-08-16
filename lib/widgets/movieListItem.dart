import 'dart:io';

import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  MovieListItem({
    this.movieName,
    this.movieDirector,
    this.imageFile,
    this.deleteMovieItem,
    this.editMovieItem,
  });
  String movieName;
  String movieDirector;
  String imageFile;
  VoidCallback deleteMovieItem;
  VoidCallback editMovieItem;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      height: height * 0.2,
      margin: EdgeInsets.only(
        left: width * 0.02,
        right: width * 0.02,
        top: width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            height: height * 0.2 - width * 0.04,
            width: (height * 0.2 - width * 0.04) * 0.75,
            child: imageFile != null
                ? Image.file(
                    File(imageFile),
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * 0.5),
                        child: Text(
                          '$movieName',
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.07),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * 0.5),
                        child: Text(
                          'by $movieDirector',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey[500],
                      ),
                      onPressed: editMovieItem,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey[500],
                      ),
                      onPressed: deleteMovieItem,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
