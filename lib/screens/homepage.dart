import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List moviesList = [];
  ScrollController _scrollController = new ScrollController();
  int itemSetLength = 10;
  File posterImage;

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          setState(() {
            itemSetLength += 10;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      final img = await ImagePicker().getImage(source: ImageSource.gallery);
      if (img == null) return;
      final imageTemporary = File(img.path);
      setState(
        () {
          this.posterImage = imageTemporary;
        },
      );
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void deleteMovieItem({int index}) {
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
  }

  void editMovieItem({int index, String type}) {
    String _movName = type == 'add' ? '' : moviesList[index]['movieName'];
    String _dirName = type == 'add' ? '' : moviesList[index]['movieDirector'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(type == "add" ? 'Add Movie' : 'Edit Movie'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _movName,
                  decoration: InputDecoration(
                    labelText: 'Movie Name',
                  ),
                  onChanged: (val) {
                    _movName = val;
                  },
                ),
                TextFormField(
                  initialValue: _dirName,
                  decoration: InputDecoration(
                    labelText: 'Director Name',
                  ),
                  onChanged: (val) {
                    _dirName = val;
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text("Add Poster"),
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
              onPressed: type == "add"
                  ? () {
                      Navigator.pop(context);
                      setState(() {
                        moviesList.add(
                          {
                            'movieName': _movName,
                            'movieDirector': _dirName,
                            'posterImage': posterImage,
                          },
                        );
                      });
                    }
                  : () {
                      Navigator.pop(context);
                      setState(
                        () {
                          moviesList[index]['movieName'] = _movName;
                          moviesList[index]['movieDirector'] = _dirName;
                        },
                      );
                    },
              child: Text(
                type == "add" ? 'Add' : 'Done',
              ),
            ),
          ],
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
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: min(moviesList.length, itemSetLength),
                    itemBuilder: (context, i) {
                      return MovieListItem(
                        movieName: moviesList[i]['movieName'],
                        movieDirector: moviesList[i]['movieDirector'],
                        imageFile: moviesList[i]['posterImage'],
                        deleteMovieItem: () => deleteMovieItem(index: i),
                        editMovieItem: () =>
                            editMovieItem(index: i, type: 'edit'),
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
        onPressed: () => editMovieItem(type: 'add'),
      ),
    );
  }
}
