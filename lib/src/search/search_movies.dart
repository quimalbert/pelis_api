import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/pages/movies/movie_detail.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:flutter/material.dart';

class SearchMovies extends SearchDelegate {
  String seleccion = '';
  final AppProvider peliculasProvider = new AppProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.releaseDate),
              onTap: () {
                close(context, null);
                Navigator.pushNamed(context, MovieDetail.routeID,
                    arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
