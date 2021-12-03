import 'package:actors_app/src/models/show_model.dart';
import 'package:actors_app/src/pages/shows/show_detail.dart';
import 'package:flutter/material.dart';

class SerieHoritzontal extends StatelessWidget {
  final List<Show> shows;
  final Function siguientePagina;

  SerieHoritzontal({@required this.shows, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: shows.length,
        itemBuilder: (context, i) => _tarjeta(context, shows[i]),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Show show) {
    show.uniqueId = '${show.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: show.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(show.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 120.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            show.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, ShowDetail.routeID, arguments: show);
      },
    );
  }
}
