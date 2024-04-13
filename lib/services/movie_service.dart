import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/genre_model.dart';
import 'package:movies_and_series_app/model/movie_model.dart';

class MovieService {
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
      throw Exception('Failed to fetch movies');
    }
  }

  static Future<List<Genre>> fetchMoviesGenres() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/genre/movie/list?api_key=${ApiConfig.apiKey}&language=tr',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data["genres"];
      return results.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch genres');
    }
  }
}
