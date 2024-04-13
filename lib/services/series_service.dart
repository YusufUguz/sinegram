import 'dart:convert';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/genre_model.dart';
import 'package:movies_and_series_app/model/series_model.dart';
import 'package:http/http.dart' as http;

class SeriesService {
  static Future<List<Series>> fetchSeriesLists(String seriesType,
      List<int> excludedGenreIds, int page, String filters) async {
    final http.Response response;
    if (seriesType == "trending") {
      response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/trending/tv/week?api_key=${ApiConfig.apiKey}&language=tr-TR&page=$page',
      ));
    } else if (seriesType == "on_the_air") {
      response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/discover/tv?api_key=${ApiConfig.apiKey}&language=tr-TR&$filters&page=$page',
      ));
    } else {
      response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/discover/tv?api_key=${ApiConfig.apiKey}&language=tr-TR$filters&page=$page',
      ));
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List<dynamic> results = data['results'];

      // Filtreleme işlemi
      final filteredResults = results
          .where((series) => !(series['genre_ids'] as List)
              .any((id) => excludedGenreIds.contains(id)))
          .toList();

      return filteredResults.map((json) => Series.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch series');
    }
  }

  static Future<List<Genre>> fetchSeriesGenres() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/genre/tv/list?api_key=${ApiConfig.apiKey}&language=tr',
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
