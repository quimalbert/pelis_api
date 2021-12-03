import 'package:actors_app/src/pages/movies/widgets/card_swiper_movies.dart';
import 'package:actors_app/src/pages/movies/widgets/pelicula_horizontal.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:actors_app/src/search/search_movies.dart';
import 'package:actors_app/src/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  static final String routeID = '/movie_page';
  final provider = new AppProvider();

  @override
  Widget build(BuildContext context) {
    provider.getPopularMovies();

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Películas TMDB'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchMovies(),
                );
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            _swiperTarjetas(),
            SizedBox(height: 20),
            _footer(context),
          ],
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: provider.getEnCinesPeliculas(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.0),
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Ya en cines',
                      style: Theme.of(context).textTheme.bodyText1)),
              SizedBox(height: 5.0),
              CardSwiperMovie(peliculas: snapshot.data),
            ],
          );
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.bodyText1)),
          SizedBox(height: 5.0),
          FutureBuilder(
            future: provider.getPopularMovies(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: provider.getPopularMovies,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
