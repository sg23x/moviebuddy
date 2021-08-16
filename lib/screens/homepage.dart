import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviebuddy/adapters/moviesAdapter.dart';
import 'package:moviebuddy/screens/login.dart';
import 'package:moviebuddy/widgets/movieListItem.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.user});
  final user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List moviesList = [];
  ScrollController _scrollController = new ScrollController();
  int itemSetLength = 5;
  String posterImage;

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          setState(() {
            itemSetLength += 5;
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
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.grey,
                  ),
                  child: TextFormField(
                    initialValue: _movName,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Movie Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      _movName = val;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.grey,
                  ),
                  child: TextFormField(
                    initialValue: _dirName,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Director Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          7,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      _dirName = val;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    box != null
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Image.file(
                              File(
                                box.getAt(index).posterImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(),
                    RaisedButton(
                      child: Text(type == "add" ? 'Add Poster' : "Edit Poster"),
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            return Text("Welcome " + snapshot.data['name']);
          },
        ),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Are you sure your want to log out?"),
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
                          FirebaseAuth.instance.signOut().then(
                            (value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Log out',
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () => editMovieItem(type: 'add'),
      ),
    );
  }
}
