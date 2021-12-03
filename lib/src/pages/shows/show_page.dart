import 'package:actors_app/src/pages/shows/widgets/card_swiper_shows.dart';
import 'package:actors_app/src/pages/shows/widgets/serie_horitzontal.dart';
import 'package:actors_app/src/provider/app_provider.dart';
import 'package:actors_app/src/search/search_shows.dart';
import 'package:actors_app/src/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ShowPage extends StatelessWidget {
  static final String routeID = '/show_page';
  final provider = new AppProvider();

  @override
  Widget build(BuildContext context) {
    provider.getPopularShows();

    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Series TMDB'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchShows(),
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
      future: provider.getTopShows(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.0),
              Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Top series',
                      style: Theme.of(context).textTheme.bodyText1)),
              SizedBox(height: 5.0),
              CardSwiperShow(shows: snapshot.data),
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
            future: provider.getPopularShows(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SerieHoritzontal(
                  shows: snapshot.data,
                  siguientePagina: provider.getPopularShows,
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
