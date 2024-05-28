import 'package:flutter/material.dart';
import 'package:movies_and_series_app/model/movie_model.dart';
import 'package:movies_and_series_app/model/series_model.dart';
import 'package:movies_and_series_app/services/movie_service.dart';
import 'package:movies_and_series_app/services/series_service.dart';

mixin HomeMixin<HomePage extends StatefulWidget> on State<HomePage>
    implements TickerProvider {
  List<Movie> topRatedMovies = [];
  List<Movie> newMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> upcomingMovies = [];
  List<Series> popularSeries = [];
  List<Series> topRatedSeries = [];
  List<Series> newEpisodes = [];
  bool isLoading = true;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchMovies("now_playing", newMovies, false);
    fetchMovies("top_rated", topRatedMovies, false);
    fetchMovies("popular", popularMovies, false);
    fetchMovies("upcoming", upcomingMovies, true);
    fetchSeries("trending", popularSeries, "");
    fetchSeries("top_rated", topRatedSeries, "&sort_by=vote_count.desc");
    fetchSeries("on_the_air", newEpisodes,
        "&sort_by=vote_count.desc&air_date.lte=2024-04-30&air_date.gte=2024-04-12");
  }

  Future<void> fetchMovies(
      String movieType, List<Movie> movieList, bool isNeedRegion) async {
    try {
      int totalPages = 5;
      List<Movie> fetchedMovies = [];
      for (int pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
        final List<Movie> currentPageMovies =
            await MovieService.fetchMoviesLists(
                movieType, isNeedRegion, pageNumber);
        fetchedMovies.addAll(currentPageMovies);
        setState(() {
          movieList.clear();
          movieList.addAll(fetchedMovies);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching movies: $e');
    }
  }

  Future<void> fetchSeries(
      String seriesType, List<Series> seriesList, String filters) async {
    try {
      int totalPages = 5;
      List<Series> fetchedSeries = [];

      for (int pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
        final List<Series> currentPageSeries =
            await SeriesService.fetchSeriesLists(
                seriesType, [10751, 10763, 10767], pageNumber, filters);

        fetchedSeries.addAll(currentPageSeries);
      }

      setState(() {
        seriesList.clear();
        seriesList.addAll(fetchedSeries);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching series: $e');
    }
  }
}
