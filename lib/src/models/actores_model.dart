class Actores {
  List<Actor> actores = [];

  Actores.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      if (actor.profilePath != null &&
          !actor.profilePath.toString().contains('svg')) actores.add(actor);
    });
  }
}

class Actor {
  String gender;
  String id;
  String name;
  double popularity;
  String department;
  String profilePath;
  List movies;

  Actor({
    this.gender,
    this.id,
    this.name,
    this.department,
    this.popularity,
    this.profilePath,
    this.movies,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    gender = json['gender'] == '1' ? 'Mujer' : 'Hombre';
    id = json['id'].toString();
    popularity = json['popularity'] as double;
    department = json['known_for_department'];
    name = json['name'];
    profilePath = json['profile_path'];
    movies = json['known_for'] as List;
  }

  getFoto() {
    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }
}
