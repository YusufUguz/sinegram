import 'package:flutter/material.dart';
import 'package:movies_and_series_app/features/genres/view/widgets/genre_card.dart';
import 'package:movies_and_series_app/features/movies_by_genre/view/movies_by_genre.dart';
import 'package:movies_and_series_app/model/genre_model.dart';
import 'package:movies_and_series_app/services/movie_service.dart';
import 'package:movies_and_series_app/widgets/loader.dart';

class MovieGenresPage extends StatefulWidget {
  const MovieGenresPage({super.key});

  @override
  State<MovieGenresPage> createState() => _MovieGenresPageState();
}

class _MovieGenresPageState extends State<MovieGenresPage> {
  List<Genre> genres = [];
  List<int> selectedGenreIds = [];
  String selectedGenreName = "";

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    try {
      final List<Genre> fetchedGenres = await MovieService.fetchMoviesGenres();
      final List<String> excludedGenres = ['TV film', 'Aile', 'Müzik'];
      setState(() {
        final List<Genre> filteredGenres = fetchedGenres.where((genre) {
          return !excludedGenres.contains(genre.name);
        }).toList();
        genres.clear();
        genres.addAll(filteredGenres);
      });
    } catch (e) {
      debugPrint('Error fetching genres: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return genres.isEmpty
        ? const Loader()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                scrollDirection: Axis.vertical,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedGenreIds.contains(genre.id)) {
                          selectedGenreIds.remove(genre.id);
                        } else {
                          selectedGenreIds.add(genre.id);
                          selectedGenreName = genre.name;
                        }
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviesByGenre(
                            selectedGenreIds: selectedGenreIds,
                            selectedGenreName: selectedGenreName,
                          ),
                        ),
                      );
                    },
                    child: GenreCard(
                      genre: genre,
                      genreType: "Movie",
                    ),
                  );
                },
              ),
            ),
          );
  }
}
