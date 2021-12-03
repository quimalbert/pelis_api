import 'package:actors_app/src/models/actores_model.dart';
import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/models/show_model.dart';
import 'package:actors_app/src/pages/movies/movie_detail.dart';
import 'package:actors_app/src/pages/shows/show_detail.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:flutter/material.dart';

class ActorDetail extends StatelessWidget {
  static final String routeID = '/actor_detalle';
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, actor),
            _descripcion(actor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Películas',
                        style: Theme.of(context).textTheme.bodyText1)),
                SizedBox(height: 5.0),
                _crearCastingPeliculas(actor),
              ],
            ),
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('Series',
                        style: Theme.of(context).textTheme.bodyText1)),
                SizedBox(height: 5.0),
                _crearCastingSeries(actor),
              ],
            ),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500" + actor.profilePath),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: actor.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(actor.getFoto()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actor.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Text(actor.department,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(actor.popularity.toString() + '/100',
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Actor actor) {
    final actoresProvider = new AppProvider();
    return FutureBuilder(
      future: actoresProvider.getActorBiography(actor.id.toString()),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Text(
              snapshot.data,
              textAlign: TextAlign.justify,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearCastingPeliculas(Actor actor) {
    final actoresProvider = new AppProvider();

    return FutureBuilder(
      future: actoresProvider.getActorMovies(actor.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearPeliculasPageView(snapshot.data);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _crearPeliculasPageView(List<Pelicula> peliculas) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: peliculas.length,
        itemBuilder: (context, i) => _peliculaTarjeta(peliculas[i], context),
      ),
    );
  }

  Widget _crearCastingSeries(Actor actor) {
    final actoresProvider = new AppProvider();

    return FutureBuilder(
      future: actoresProvider.getActorShows(actor.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearSeriesPageView(snapshot.data);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _crearSeriesPageView(List<Show> shows) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: shows.length,
        itemBuilder: (context, i) => _seriesTarjeta(shows[i], context),
      ),
    );
  }

  Widget _peliculaTarjeta(Pelicula pelicula, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, MovieDetail.routeID,
          arguments: pelicula),
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(pelicula.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
    );
  }

  Widget _seriesTarjeta(Show show, BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ShowDetail.routeID, arguments: show),
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(show.getPosterImg()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            show.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
    );
  }
}
