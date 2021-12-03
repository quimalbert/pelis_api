import 'package:actors_app/src/pages/movies/movie_page.dart';
import 'package:actors_app/src/pages/shows/show_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      child: Container(
        width: 200,
        child: Drawer(
          elevation: 10,
          backgroundColor: Colors.redAccent,
          child: Column(
            children: [
              Image.asset('assets/img/logo.png'),
              ListTile(
                title: Text('Actores'),
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onTap: () => Navigator.pushNamed(context, '/'),
              ),
              ListTile(
                title: Text('Películas'),
                leading: Icon(
                  Icons.local_movies_outlined,
                  color: Colors.black,
                ),
                onTap: () => Navigator.pushNamed(context, MoviePage.routeID),
              ),
              ListTile(
                title: Text('Series'),
                leading: Icon(
                  Icons.live_tv,
                  color: Colors.black,
                ),
                onTap: () => Navigator.pushNamed(context, ShowPage.routeID),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
