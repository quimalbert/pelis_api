import 'dart:async';
import 'dart:convert';

import 'package:actors_app/src/models/actores_model.dart';
import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/models/show_model.dart';
import 'package:http/http.dart' as http;

class AppProvider {
  String _apikey = 'ab85e2ec67c3e9d2e7970e8fd9c24fdd';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _actoresPopularesPage = 0;
  int _peliculasPopularesPage = 0;
  bool _cargando = false;

  List<Actor> _actoresPopulares = [];
  List<Pelicula> _peliculasPopulares = [];

  final _actoresPopularesStreamController =
      StreamController<List<Actor>>.broadcast();
  final _peliculasPopularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get peliculasPopularesSink =>
      _peliculasPopularesStreamController.sink.add;

  Function(List<Actor>) get actoresPopularesSink =>
      _actoresPopularesStreamController.sink.add;

  Stream<List<Actor>> get actoresPopularesStream =>
      _actoresPopularesStreamController.stream;

  Stream<List<Actor>> get peliculasPopularesStream =>
      _actoresPopularesStreamController.stream;

  void disposeStreams() {
    _actoresPopularesStreamController?.close();
    _peliculasPopularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuestaActores(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final actores = new Actores.fromJsonList(decodedData['results']);

    return actores.actores;
  }

  Future<List<Pelicula>> _procesarRespuestaPeliculas(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Show>> _procesarRespuestaShows(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final shows = new Shows.fromJsonList(decodedData['results']);

    return shows.items;
  }

  Future<List<Actor>> getTrendingActores() async {
    final url = Uri.https(_url, '3/trending/person/week',
        {'api_key': _apikey, 'language': _language});
    return await _procesarRespuestaActores(url);
  }

  Future<List<Pelicula>> getEnCinesPeliculas() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await _procesarRespuestaPeliculas(url);
  }

  Future<List<Show>> getPopularShows() async {
    final url = Uri.https(
        _url, '3/tv/popular', {'api_key': _apikey, 'language': _language});
    return await _procesarRespuestaShows(url);
  }

  Future<List<Show>> getTopShows() async {
    final url = Uri.https(
        _url, '3/tv/top_rated', {'api_key': _apikey, 'language': _language});
    return await _procesarRespuestaShows(url);
  }

  Future<String> getActorBiography(String actorID) async {
    final url = Uri.https(
        _url, '3/person/$actorID', {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    return decodedData['biography'];
  }

  Future<List<Actor>> getPopularActors() async {
    if (_cargando) return [];

    _cargando = true;
    _actoresPopularesPage++;

    final url = Uri.https(_url, '3/person/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _actoresPopularesPage.toString()
    });
    final resp = await _procesarRespuestaActores(url);

    _actoresPopulares.addAll(resp);
    actoresPopularesSink(_actoresPopulares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> getPopularMovies() async {
    _peliculasPopularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _peliculasPopularesPage.toString()
    });
    final resp = await _procesarRespuestaPeliculas(url);

    _peliculasPopulares.addAll(resp);
    peliculasPopularesSink(_peliculasPopulares);

    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language}); // pelicula

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Actores.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Actor>> getShowCast(String showID) async {
    final url = Uri.https(_url, '3/tv/$showID/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Actores.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> getActorMovies(String actorID) async {
    final url = Uri.https(_url, '3/person/$actorID/movie_credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Peliculas.fromJsonList(decodedData['cast']);

    return cast.items;
  }

  Future<List<Show>> getActorShows(String actorID) async {
    final url = Uri.https(_url, '3/person/$actorID/tv_credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Shows.fromJsonList(decodedData['cast']);

    return cast.items;
  }

  Future<List<Actor>> searchActor(String query) async {
    final url = Uri.https(_url, '3/search/person',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuestaActores(url);
  }

  Future<List<Pelicula>> searchMovies(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuestaPeliculas(url);
  }

  Future<List<Show>> searchShow(String query) async {
    final url = Uri.https(_url, '3/search/tv',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuestaShows(url);
  }
}
