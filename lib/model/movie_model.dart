class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String wideImagePath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.wideImagePath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json["title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      voteAverage: json["vote_average"].toDouble(),
      wideImagePath: json["backdrop_path"],
    );
  }
}
