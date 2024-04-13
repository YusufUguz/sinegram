class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String wideImagePath;
  final List<dynamic> genreIds;
  final String releaseDate;

  Movie(
      {required this.id,
      required this.title,
      required this.overview,
      required this.posterPath,
      required this.voteAverage,
      required this.wideImagePath,
      required this.releaseDate,
      required this.genreIds});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: json["title"] ?? "",
        overview: json["overview"] ?? "",
        posterPath: json["poster_path"] ?? "",
        voteAverage: json["vote_average"].toDouble(),
        wideImagePath: json["backdrop_path"] ?? "",
        genreIds: json["genre_ids"],
        releaseDate: json["release_date"]);
  }

  @override
  String toString() {
    return 'Movie{title: $title, id: $id}';
  }
}
