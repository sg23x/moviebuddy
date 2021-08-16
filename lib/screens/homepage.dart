import 'dart:io';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviebuddy/adapters/moviesAdapter.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List moviesList = [];
  ScrollController _scrollController = new ScrollController();
  int itemSetLength = 10;
  String posterImage;

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

  void addMovie(name, dir, img) {
    Box<Movie> movbox = Hive.box<Movie>('movies');
    movbox.add(
      Movie(
        movieName: name,
        movieDirector: dir,
        posterImage: img,
      ),
    );
  }

  void editMovie(name, dir, img, index) {
    Box<Movie> movbox = Hive.box<Movie>('movies');
    movbox.putAt(
      index,
      Movie(
        movieName: name,
        movieDirector: dir,
        posterImage: img,
      ),
    );
  }

  Future pickImg() async {
    final img = await ImagePicker().getImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      this.posterImage = img.path;
    });
  }

  void deleteMovieItem({int index, Box box}) {
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
                box.deleteAt(index);
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

  void editMovieItem({int index, String type, Box box}) {
    String _movName = type == 'add' ? '' : box.getAt(index).movieName;
    String _dirName = type == 'add' ? '' : box.getAt(index).movieDirector;
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
                Row(
                  children: [
                    box != null
                        ? Container(
                            height: 100,
                            child: Image.file(
                              File(
                                box.getAt(index).posterImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(),
                    RaisedButton(
                      onPressed: () {
                        pickImg();
                      },
                    ),
                  ],
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
                      addMovie(
                        _movName,
                        _dirName,
                        posterImage,
                      );
                      Navigator.pop(context);
                    }
                  : () {
                      editMovie(_movName, _dirName, posterImage, index);
                      Navigator.pop(context);
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Movie>('movies').listenable(),
        builder: (context, Box<Movie> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('Movies list is empty'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: min(box.length, itemSetLength),
                  itemBuilder: (context, i) {
                    Movie mov = box.getAt(i);
                    return MovieListItem(
                      movieDirector: mov.movieDirector,
                      movieName: mov.movieName,
                      imageFile: mov.posterImage,
                      deleteMovieItem: () =>
                          deleteMovieItem(index: i, box: box),
                      editMovieItem: () =>
                          editMovieItem(index: i, type: 'edit', box: box),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
