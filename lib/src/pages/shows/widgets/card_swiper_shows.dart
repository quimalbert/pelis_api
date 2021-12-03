import 'package:actors_app/src/models/show_model.dart';
import 'package:actors_app/src/pages/shows/show_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiperShow extends StatelessWidget {
  final List<Show> shows;

  CardSwiperShow({@required this.shows});

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
          shows[index].uniqueId = '${shows[index].id}-tarjeta';

          return Hero(
            tag: shows[index].id,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ShowDetail.routeID,
                      arguments: shows[index]),
                  child: FadeInImage(
                    image: NetworkImage(shows[index].getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: shows.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
