import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/features/home/view/widgets/movies/movie_card.dart';
import 'package:movies_and_series_app/model/movie_model.dart';
import "package:http/http.dart" as http;
import 'package:movies_and_series_app/widgets/loader.dart';

class MoviesByGenre extends StatefulWidget {
  const MoviesByGenre(
      {super.key,
      required this.selectedGenreIds,
      required this.selectedGenreName});

  final List<int> selectedGenreIds;
  final String selectedGenreName;
  @override
  State<MoviesByGenre> createState() => _MoviesByGenreState();
}

class _MoviesByGenreState extends State<MoviesByGenre> {
  @override
  void initState() {
    super.initState();
    fetchAllMovies();
  }

  List<Movie> allMovies = [];

  Future<void> fetchAllMovies() async {
    const int totalPages = 100;

    for (int page = 1; page <= totalPages; page++) {
      List<Movie> currentPageMovies = await fetchMoviesForPage(page);
      setState(() {
        allMovies.addAll(currentPageMovies);
      });
    }

    debugPrint('Toplam ${allMovies.length} film çekildi.');
  }

  Future<List<Movie>> fetchMoviesForPage(int page) async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/discover/movie?api_key=${ApiConfig.apiKey}&include_adult=false&language=tr-TR&sort_by=vote_count.desc&without_genres=10770%2C10402%2C10751&page=$page',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      List<Movie> movies = results.map((json) => Movie.fromJson(json)).toList();
      List<Movie> filteredMovies = [];

      for (var movie in movies) {
        if (movie.genreIds.any((id) => widget.selectedGenreIds.contains(id))) {
          filteredMovies.add(movie);
        }
      }

      return filteredMovies;
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(allMovies.length.toString());
    /* debugPrint(allMovies.toList().toString()); */
    debugPrint("selected genre:${widget.selectedGenreIds.length.toString()}");
    return allMovies.isEmpty
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: Text("${widget.selectedGenreName} Filmleri"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: allMovies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.65, crossAxisCount: 2),
                  itemBuilder: ((context, index) {
                    final movie = allMovies[index];
                    return MovieCard(movie: movie);
                  })),
            ));
  }
}
