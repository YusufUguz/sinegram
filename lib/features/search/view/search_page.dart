import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/features/movie_details/view/movie_details_page.dart';
import 'package:movies_and_series_app/features/series_details/view/series_details_page.dart';
import 'package:movies_and_series_app/model/search_results_model.dart';
import 'package:movies_and_series_app/services/movie_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchFieldController = TextEditingController();

  List<SearchResults> searchResults = [];

  Future<void> fetchSearchResults(List<SearchResults> movieList) async {
    int totalPages = 5;
    List<SearchResults> fetchedMovies = [];
    for (int pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
      final List<SearchResults> currentPageMovies =
          await MovieService.fetchSearch(
              pageNumber, searchFieldController.text);
      fetchedMovies.addAll(currentPageMovies);
      setState(() {
        movieList.clear();
        movieList.addAll(fetchedMovies);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Film/Dizi Ara"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: searchFieldController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      fetchSearchResults(searchResults);
                      if (searchResults.isEmpty) {}
                    },
                    icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                    color: Constants.appsLighterMainColor,
                  ),
                  labelText: "Arama Yap..",
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Constants.appsLighterMainColor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.appsLighterMainColor, width: 2))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: searchResults.isEmpty
                    ? Container()
                    : searchFieldController.text != "" && searchResults.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Aradığınız film veya dizi bulunamadı,doğru yazdığınızdan emin olunuz.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.65, crossAxisCount: 2),
                            scrollDirection: Axis.vertical,
                            itemCount: searchResults.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final movie = searchResults[index];
                              return GestureDetector(
                                onTap: () {
                                  searchResults[index].mediaType == "movie"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return MovieDetailsPage(
                                              movieID: movie.id,
                                            );
                                          }),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return SeriesDetailsPage(
                                                seriesID: movie.id);
                                          }),
                                        );
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                                              fit: BoxFit.fill,
                                              height: 200,
                                              width: 180,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          /* Positioned(
                  top: 5,
                  right: 10,
                  child: movie.voteAverage == 0
                      ? Container()
                      : /* RatingContainerMovies(movie: movie) */
              ;), */
                                        ],
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 180,
                                          child: Center(
                                            child: Text(
                                              movie.name,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.visible,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
