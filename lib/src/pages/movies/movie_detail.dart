import 'package:actors_app/src/models/actores_model.dart';
import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/pages/actors/actor_detail.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatelessWidget {
  static final String routeID = '/pelicula_detalle';

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitulo(context, pelicula),
            _descripcion(pelicula),
            _crearCasting(pelicula),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500" + pelicula.backdropPath),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(pelicula.getPosterImg()),
              height: 150.0,
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(),
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

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new AppProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i], context),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor, BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ActorDetail.routeID, arguments: actor),
      child: Container(
          child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      )),
    );
  }
}
