import 'package:actors_app/src/pages/actors/actor_detail.dart';
import 'package:actors_app/src/pages/actors/actor_page.dart';
import 'package:actors_app/src/pages/movies/movie_detail.dart';
import 'package:actors_app/src/pages/movies/movie_page.dart';
import 'package:actors_app/src/pages/shows/show_detail.dart';
import 'package:actors_app/src/pages/shows/show_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas TMDB',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => ActorPage(),
        MoviePage.routeID: (BuildContext context) => MoviePage(),
        ActorDetail.routeID: (BuildContext context) => ActorDetail(),
        MovieDetail.routeID: (BuildContext context) => MovieDetail(),
        ShowPage.routeID: (BuildContext context) => ShowPage(),
        ShowDetail.routeID: (BuildContext context) => ShowDetail(),
      },
    );
  }
}
