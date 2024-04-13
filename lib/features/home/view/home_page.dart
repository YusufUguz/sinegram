import 'package:flutter/material.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/features/home/view/widgets/movies/movies_section.dart';
import 'package:movies_and_series_app/features/home/view/widgets/series/series_section.dart';
import 'package:movies_and_series_app/features/home/view_model/mixin/home_mixin.dart';
import 'package:movies_and_series_app/widgets/loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, HomeMixin {
  @override
  Widget build(BuildContext context) {
    int todaysFilm = 0;
    int todaysSeries = 0;
    debugPrint("popular movies lentgh : ${popularMovies.length.toString()}");
    debugPrint("new movies lentgh : ${newMovies.length.toString()}");
    debugPrint("toprated series lentgh : ${topRatedMovies.length.toString()}");
    debugPrint("upcoming series lentgh : ${popularSeries.length.toString()}");

    return topRatedMovies.isEmpty || topRatedSeries.isEmpty
        ? const Loader()
        : Scaffold(
            body: Column(
              children: [
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xff24292F),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                        color: Constants.appsLighterMainColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      tabs: const [
                        Tab(
                          text: 'FİLMLER',
                        ),
                        Tab(
                          text: 'DİZİLER',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      MoviesSection(
                        topRatedMovies: topRatedMovies,
                        todaysFilm: todaysFilm,
                        newMovies: newMovies,
                        popularMovies: popularMovies,
                        upcomingMovies: upcomingMovies,
                      ),
                      SeriesSection(
                        topRatedSeries: topRatedSeries,
                        todaysSeries: todaysSeries,
                        popularSeries: popularSeries,
                        newEpisodes: newEpisodes,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
