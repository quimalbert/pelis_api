import 'package:actors_app/src/models/show_model.dart';
import 'package:actors_app/src/pages/shows/show_detail.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:flutter/material.dart';

class SearchShows extends SearchDelegate {
  String seleccion = '';
  final AppProvider showProvider = new AppProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
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
      future: showProvider.searchShow(query),
      builder: (BuildContext context, AsyncSnapshot<List<Show>> snapshot) {
        if (snapshot.hasData) {
          final shows = snapshot.data;

          return ListView(
              children: shows.map((show) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(show.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(show.name),
              subtitle: Text(show.voteAverage.toString() + '/10'),
              onTap: () {
                close(context, null);
                Navigator.pushNamed(context, ShowDetail.routeID,
                    arguments: show);
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
