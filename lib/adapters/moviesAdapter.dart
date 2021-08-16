import 'dart:io';
import 'package:hive/hive.dart';

part 'moviesAdapter.g.dart';

@HiveType(typeId: 1)
class Movie {
  @HiveField(0)
  String movieName;

  @HiveField(1)
  String movieDirector;

  @HiveField(2)
  File posterImage;

  Movie({this.movieName, this.movieDirector, this.posterImage});
}
