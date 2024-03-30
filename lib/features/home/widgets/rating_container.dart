import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/model/movie_model.dart';

class RatingContainer extends StatelessWidget {
  const RatingContainer({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    late Color containerColor;
    if (movie.voteAverage > 6.5) {
      containerColor = Colors.green;
    } else if (movie.voteAverage <= 6.5) {
      containerColor = Colors.blue;
    } else if (movie.voteAverage < 4) {
      containerColor = Colors.red;
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: containerColor),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.solidStar,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              (movie.voteAverage).toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
