import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/features/home/view/widgets/series/rating_container_series.dart';
import 'package:movies_and_series_app/model/series_model.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({
    super.key,
    required this.series,
  });

  final Series series;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConfig.imageBaseUrl}${series.posterPath}',
                  fit: BoxFit.fill,
                  height: 200,
                  width: 180,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              series.voteAverage == 0
                  ? Container()
                  : Positioned(
                      top: 5,
                      right: 10,
                      child: RatingContainerSeries(series: series),
                    ),
            ],
          ),
          Expanded(
            child: SizedBox(
              width: 180,
              child: Center(
                child: Text(
                  series.title,
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
  }
}
