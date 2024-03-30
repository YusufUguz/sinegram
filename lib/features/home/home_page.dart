import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/movie_model.dart';
import 'package:movies_and_series_app/features/home/widgets/movie_list.dart';
import 'package:movies_and_series_app/services/movie_service.dart';
import 'widgets/home_page_titles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> topRatedMovies = [];
  List<Movie> newMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies("top_rated", topRatedMovies);
    fetchMovies("now_playing", newMovies);
  }

  Future<void> fetchMovies(String movieType, List<Movie> movieList) async {
    try {
      final List<Movie> fetchedMovies =
          await MovieService.fetchMovies(movieType);
      setState(() {
        movieList.clear();
        movieList.addAll(fetchedMovies);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int todaysFilm = 0;

    return isLoading
        ? Scaffold(
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(100)),
                          image: DecorationImage(
                              image: NetworkImage(topRatedMovies.isNotEmpty
                                  ? '${ApiConfig.imageBaseUrl}${topRatedMovies[todaysFilm].wideImagePath}'
                                  : ""),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken))),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Chip(
                              avatar: Icon(
                                FontAwesomeIcons.film,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Günün Filmi",
                                style: TextStyle(),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  topRatedMovies[todaysFilm].title,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                Chip(
                                  label: Text(
                                    (topRatedMovies[todaysFilm].voteAverage)
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  avatar: const Icon(
                                    FontAwesomeIcons.solidStar,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomePageTitles(
                            title: "Yeni Çıkanlar",
                          ),
                          MovieList(movies: newMovies),
                          HomePageTitles(title: "Klasik Filmler"),
                          MovieList(movies: topRatedMovies),
                        ],
                      ),
                    ),
                  ]),
            ),
          );
  }
}
