import 'package:actors_app/src/pages/actors/widgets/actor_horizontal.dart';
import 'package:actors_app/src/pages/actors/widgets/card_swiper_actores.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:actors_app/src/search/search_actors.dart';
import 'package:actors_app/src/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ActorPage extends StatelessWidget {
  final actoresProvider = new AppProvider();

  @override
  Widget build(BuildContext context) {
    actoresProvider.getPopularActors();

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Actores TMDB'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchActors(),
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
      future: actoresProvider.getTrendingActores(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Trending semanal',
                      style: Theme.of(context).textTheme.bodyText1)),
              SizedBox(height: 5.0),
              CardSwiperActores(actores: snapshot.data),
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
          StreamBuilder(
            stream: actoresProvider.actoresPopularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ActorHorizontal(
                  actores: snapshot.data,
                  siguientePagina: actoresProvider.getPopularActors,
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
