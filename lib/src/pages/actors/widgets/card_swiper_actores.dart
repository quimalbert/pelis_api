import 'package:actors_app/src/models/actores_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../actor_detail.dart';

class CardSwiperActores extends StatelessWidget {
  final List<Actor> actores;

  CardSwiperActores({@required this.actores});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemCount: actores.length,
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          actores[index].id = '${actores[index].id}-tarjeta';
          return Hero(
            tag: actores[index].id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ActorDetail.routeID,
                      arguments: actores[index]),
                  child: FadeInImage(
                    image: NetworkImage(actores[index].getFoto()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
      ),
    );
  }
}
