import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/genre_model.dart';
import 'package:movies_and_series_app/model/movie_credits_model.dart';
import 'package:movies_and_series_app/model/movie_details_model.dart';
import 'package:movies_and_series_app/model/movie_model.dart';
import 'package:movies_and_series_app/model/search_results_model.dart';

class MovieService {
  static Future<List<Movie>> fetchMovies(int page) async {
    final http.Response response;

    response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/discover/movie?api_key=${ApiConfig.apiKey}&language=tr-TR&region=TR&page=$page&sort_by=vote_count.desc',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> results = data['results'];

      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  static Future<List<SearchResults>> fetchSearch(int page, String query) async {
    final http.Response response;

    response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/search/multi?query=$query&api_key=${ApiConfig.apiKey}&language=tr-TR&region=TR&page=$page',
    ));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> results = data['results'];

      return results.map((json) => SearchResults.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch Search results');
    }
  }

  static Future<List<Movie>> fetchMoviesLists(
      String movieType, bool isNeedRegion, int page) async {
    final http.Response response;
    if (isNeedRegion) {
      response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/movie/$movieType?api_key=${ApiConfig.apiKey}&language=tr-TR&region=TR&page=$page',
      ));
    } else {
      response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/movie/$movieType?api_key=${ApiConfig.apiKey}&language=tr-TR&page=$page',
      ));
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> results = data['results'];

      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies list');
    }
  }

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    final http.Response response;
    response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/movie/$movieId?api_key=${ApiConfig.apiKey}&language=tr-TR'));

    if (response.statusCode == 200) {
      return MovieDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<MovieCredits>> fetchMovieCredits(int movieID) async {
    final http.Response response;
    response = await http.get(Uri.parse(
        "${ApiConfig.baseUrl}/movie/$movieID/credits?api_key=${ApiConfig.apiKey}&language=tr-TR"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> results = data['cast'];

      return results.map((json) => MovieCredits.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

  static Future<List<GeneralGenre>> fetchMoviesGenres() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/genre/movie/list?api_key=${ApiConfig.apiKey}&language=tr',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data["genres"];
      return results.map((json) => GeneralGenre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch genres');
    }
  }
}
