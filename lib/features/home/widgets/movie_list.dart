import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/model/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies_and_series_app/features/home/widgets/rating_container.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 1.25 / 3,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                        fit: BoxFit.fill,
                        height: 200,
                        width: 180,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: RatingContainer(movie: movie),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: 180,
                    child: Center(
                      child: Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
