import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/movie_model.dart';

class MovieService {
  static Future<List<Movie>> fetchMovies(String movieType) async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/movie/$movieType?api_key=${ApiConfig.apiKey}&language=tr-TR',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}
