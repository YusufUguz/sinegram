import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movies_and_series_app/core/constants.dart';
import 'package:movies_and_series_app/features/lists/view/listed_movies.dart';
import 'package:movies_and_series_app/features/login-register/view/login_register_page.dart';
import 'package:movies_and_series_app/model/user_model.dart';

// ignore: must_be_immutable
class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? usersData;
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      user;
    });
    if (user != null) {
      setState(() {
        fetchUserData(user!.uid);
      });
    }
  }

  Future<void> fetchUserData(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      usersData = UserModel.fromFirestore(userSnapshot, null);

      // Diğer kullanıcı özelliklerini burada kullanabilirsiniz
    } else {
      debugPrint('Kullanıcı bulunamadı!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.bookmark,
                    size: 100,
                    color: Constants.appsLighterMainColor,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Liste Oluşturabilmek İçin Giriş Yapmanız Gerekmektedir.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.appsMainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginRegisterPage();
                        }));
                      },
                      child: const Text(
                        'Giriş Yap / Kayıt Ol',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Liste Oluştur"),
                      content: TextField(
                        controller: _listNameController,
                        decoration: const InputDecoration(
                            hintText: "Liste Adını Giriniz",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("İptal")),
                        TextButton(
                            onPressed: () {
                              // Liste adını al
                              String listName = _listNameController.text.trim();
                              // Boşsa işlem yapma
                              if (listName.isEmpty) return;

                              // Firestore referansı oluştur
                              FirebaseFirestore firestore =
                                  FirebaseFirestore.instance;
                              // Kullanıcı belgesine referans al
                              DocumentReference userDocRef =
                                  firestore.collection('users').doc(user!.uid);

                              // Listeyi ekle
                              userDocRef.update({
                                listName:
                                    [], // Boş bir liste olarak ekleyebilirsiniz, daha sonra içeriği güncelleyebilirsiniz
                              }).then((_) {
                                // Ekleme başarılı, diyalogu kapat
                                Navigator.pop(context);
                                // Kullanıcı verilerini yeniden yükle
                                setState(() {
                                  fetchUserData(user!.uid);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Liste oluşturuldu"),
                                  ),
                                );
                              }).catchError((error) {
                                // Hata durumunda kullanıcıya bilgi ver
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Liste eklenirken bir hata oluştu: $error"),
                                  ),
                                );
                              });
                            },
                            child: const Text("Ekle"))
                      ],
                    );
                  },
                );
              },
              child: const Icon(FontAwesomeIcons.plus),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text("Bir hata oluştu: ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      // Belgeden veriyi alın
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      // İstenmeyen alanları kaldırın
                      data.remove('email');
                      data.remove('username');
                      data.remove('password');

                      List<String> titles = data.keys.toList();
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (snapshot, index) {
                            return GestureDetector(
                              onTap: () {
                                if (data[titles[index]] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListedMovies(
                                            movieIDs: data[titles[index]])),
                                  );
                                }
                              },
                              onLongPress: (){
                                
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      titles[index] == "Favorilerim"
                                          ? const Icon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.red,
                                            )
                                          : titles[index] ==
                                                  "Daha Sonra İzlenecekler"
                                              ? const Icon(
                                                  FontAwesomeIcons.clock)
                                              : const Icon(FontAwesomeIcons
                                                  .solidBookmark),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        titles[index],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Text("Belge bulunamadı!");
                    }
                  }

                  return const Center(
                      child:
                          CircularProgressIndicator()); // Veri yüklenirken gösterilecek ilerleme çubuğu
                },
              ),
            ));
  }
}
