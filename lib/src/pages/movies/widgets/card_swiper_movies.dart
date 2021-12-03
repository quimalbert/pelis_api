import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/pages/movies/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiperMovie extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiperMovie({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, MovieDetail.routeID,
                      arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(peliculas[index].getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
