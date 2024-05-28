// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/core/api_config.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/features/movie_details/view/widgets/info_container.dart';
import 'package:movies_and_series_app/model/movie_credits_model.dart';
import 'package:movies_and_series_app/model/movie_details_model.dart';

Widget buildMovieDetails(
    MovieDetails movieDetails,
    BuildContext context,
    List<MovieCredits> movieCredits,
    List<dynamic> buyData,
    List<dynamic> flatrateData) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        PictureArea(movieDetails: movieDetails),
        Tagline(movieDetails: movieDetails),
        MovieCategories(movieDetails: movieDetails),
        InfoContainer(
          movieDetails: movieDetails,
        ),
        MovieDetailsTitles(
          title: "Genel Bakış",
        ),
        MovieOverview(movieDetails: movieDetails),
        MovieDetailsTitles(title: "Oyuncular"),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: movieCredits.length,
              itemBuilder: (context, index) {
                final movieCredit = movieCredits[index];
                return Card(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: movieCredit.profilePath.isEmpty
                            ? Image.asset(
                                "assets/icons/movie3.png",
                                width: 170,
                                height: 190,
                              )
                            : Image.network(
                                "${ApiConfig.imageBaseUrl}${movieCredit.profilePath}",
                                width: 170,
                                height: 190,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                movieCredit.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                movieCredit.character,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        MovieDetailsTitles(title: "Yayınlanan Platformlar"),
        buyData.isEmpty && flatrateData.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Film şuan sinemalarda olabilir veya Türkiye'de filmin yayınlandığı bir platform bulunmamaktadır.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: buyData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    "${ApiConfig.imageBaseUrl}${buyData[index]['logo_path']}",
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  buyData[index]['provider_name'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: flatrateData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    "${ApiConfig.imageBaseUrl}${flatrateData[index]['logo_path']}",
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  flatrateData[index]['provider_name'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        MovieDetailsTitles(
          title: "Bazı Bilgiler",
        ),
        BudgetInfoCard(
          movieDetails: movieDetails,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: Constants.appsLighterMainColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    FontAwesomeIcons.clapperboard,
                    color: Constants.appsMainColor,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Filmin Yapımcı Şirketleri",
                              style: TextStyle(
                                  fontSize: 18, color: Constants.appsMainColor),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: movieDetails.productionCompanies.length,
                          itemBuilder: ((context, index) {
                            final productionCompanies =
                                movieDetails.productionCompanies[index];
                            return Row(
                              children: [
                                productionCompanies.logoPath == ""
                                    ? Image.asset(
                                        "assets/icons/movie3.png",
                                        height: 30,
                                        width: 50,
                                      )
                                    : Image.network(
                                        "${ApiConfig.imageBaseUrl}${productionCompanies.logoPath}",
                                        width: 50,
                                        height: 30,
                                      ),
                                Expanded(
                                  child: Text(
                                    productionCompanies.name,
                                    style: const TextStyle(
                                        color: Constants.appsMainColor,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.calendar,
                    color: Constants.appsLighterMainColor,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Filmin vizyon tarihi ${movieDetails.releaseDate}'dir.",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class MovieOverview extends StatelessWidget {
  MovieOverview({
    super.key,
    required this.movieDetails,
  });

  MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Text(
        movieDetails.overview,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class MovieDetailsTitles extends StatelessWidget {
  MovieDetailsTitles({
    super.key,
    required this.title,
  });

  String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}

class MovieCategories extends StatelessWidget {
  MovieCategories({
    super.key,
    required this.movieDetails,
  });

  MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 40,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: movieDetails.genres.length,
            itemBuilder: (context, index) {
              final movieGenre = movieDetails.genres[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 120,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Constants.appsLighterMainColor),
                  child: Center(
                    child: Text(
                      movieGenre.name,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class Tagline extends StatelessWidget {
  Tagline({
    super.key,
    required this.movieDetails,
  });

  MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "\"${movieDetails.tagline}\"",
        style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
      ),
    );
  }
}

class BudgetInfoCard extends StatelessWidget {
  BudgetInfoCard({
    super.key,
    required this.movieDetails,
  });

  MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.dollarSign,
                color: Constants.appsLighterMainColor,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Bu filmin yapımında ${movieDetails.budget} \$ harcanmıştır.",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PictureArea extends StatefulWidget {
  PictureArea({
    super.key,
    required this.movieDetails,
  });

  MovieDetails movieDetails;

  @override
  State<PictureArea> createState() => _PictureAreaState();
}

class _PictureAreaState extends State<PictureArea> {
  final user = FirebaseAuth.instance.currentUser;

  bool isFavorite = false;

  Future<bool> checkFavorite(int movieID) async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final List<dynamic> favorites = userDoc.data()?['Favorilerim'] ?? [];
      return favorites.contains(movieID);
    } else {
      return false;
    }
  }

  Future<void> addToFavorites(int movieID) async {
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      await userDoc.update({
        'Favorilerim': FieldValue.arrayUnion([movieID])
      });
    } else {
      // Handle the case when the user is not signed in
    }
  }

  Future<void> removeFromFavorites(int movieID) async {
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);

      await userDoc.update({
        'Favorilerim': FieldValue.arrayRemove([movieID])
      });
    } else {
      // Handle the case when the user is not signed in
    }
  }

  @override
  void initState() {
    super.initState();
    checkFavorite(widget.movieDetails.id).then(
      (value) {
        setState(() {
          isFavorite = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
          image: DecorationImage(
              image: NetworkImage(
                  "${ApiConfig.imageBaseUrl}${widget.movieDetails.backdropPath}"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken))),
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
                    widget.movieDetails.title.toUpperCase(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      (widget.movieDetails.voteAverage).toStringAsFixed(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
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
                onPressed: () {
                  if (user == null) {
                    Fluttertoast.showToast(
                        msg: "Favorilere kaydetmek için giriş yapmalısınız.",
                        toastLength: Toast.LENGTH_LONG,
                        fontSize: 18);
                  } else {
                    if (isFavorite == false) {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          '"Favorilerim" listesine eklendi.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                      addToFavorites(widget.movieDetails.id).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                      setState(() {
                        isFavorite = true;
                      });
                    } else if (isFavorite == true) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Favorilerimden Kaldır",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                "Filmi Favorilerim listesinden kaldırmak istediğinize emin misiniz?",
                                style: TextStyle(fontSize: 17),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Hayır"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    const snackBar = SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        'Film "Favorilerim" listesinden kaldırıldı.',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    );
                                    removeFromFavorites(widget.movieDetails.id)
                                        .then((value) {
                                      setState(() {
                                        isFavorite = false;
                                      });
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Evet"),
                                ),
                              ],
                            );
                          });
                    }
                  }
                },
                icon: Icon(
                  isFavorite == true
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
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
    );
  }
}
