import 'package:flutter/material.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List moviesList = [];

  void deleteMovieItem(index) {
    setState(
      () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  "Are you sure your want to delete this Movie from the list?"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.pink,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      moviesList.removeAt(index);
                    });
                  },
                  child: Text(
                    'Delete',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Soumya!'),
      ),
      body: moviesList.isEmpty
          ? Center(
              child: Text('Movies list is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: moviesList.length,
                    itemBuilder: (context, i) {
                      return MovieListItem(
                        movieName: moviesList[i]['movieName'],
                        movieDirector: moviesList[i]['movieDirector'],
                        deleteMovieItem: () => deleteMovieItem(i),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String _movName = '';
              String _dirName = '';
              return AlertDialog(
                title: Text(
                  'Add Movie',
                ),
                content: Container(
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Movie Name',
                        ),
                        onChanged: (val) {
                          _movName = val;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Director Name',
                        ),
                        onChanged: (val) {
                          _dirName = val;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(
                        () {
                          moviesList.add(
                            {
                              'movieName': _movName,
                              'movieDirector': _dirName,
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Add',
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
