import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/model/series_details_model.dart';
import 'package:movies_and_series_app/services/series_service.dart';

class SeriesDetailsPage extends StatefulWidget {
  const SeriesDetailsPage({super.key, required this.seriesID});
  final int seriesID;
  @override
  State<SeriesDetailsPage> createState() => _SeriesDetailsPageState();
}

class _SeriesDetailsPageState extends State<SeriesDetailsPage> {
  late Future<SeriesDetails> _futureSeriesDetails;

  @override
  void initState() {
    super.initState();
    _futureSeriesDetails = SeriesService().fetchSeriesDetails(widget.seriesID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dizi Detayları"),
        centerTitle: true,
      ),
      body: FutureBuilder<SeriesDetails>(
        future: _futureSeriesDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            SeriesDetails series = snapshot.data!;
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      image: DecorationImage(
                          image: NetworkImage(
                              "${ApiConfig.imageBaseUrl}${series.backdropPath}"),
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                series.name.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                              ),
                              Chip(
                                label: Text(
                                  (series.voteAverage).toStringAsFixed(1),
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
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FontAwesomeIcons.heart,
                              size: 27,
                              color: Constants.appsLighterMainColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FontAwesomeIcons.bookmark,
                              size: 27,
                              color: Constants.appsLighterMainColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
