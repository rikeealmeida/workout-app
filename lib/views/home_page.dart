import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/user_model.dart';
import 'package:workout_app/services/auth_service.dart';
import 'package:workout_app/views/create_user.dart';
import 'package:workout_app/views/tabs/home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  final authService = AuthService();
  int selectedIndex = 0;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  var uuid;
  Future checkRegistry() async {
    final uid = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final docSnap = await uid.get();
    setState(() {
      uuid = docSnap.data();
    });
  }

  @override
  void initState() {
    checkRegistry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Registry'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User')
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Workout App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () {
              authService.logout();
            },
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: const Text(
                  'Sair',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.purple.withOpacity(.5)),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.8),
                          blurRadius: 10,
                          offset: const Offset(0, 1))
                    ],
                    color: Colors.purple,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(firebaseUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data?.data() == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Você precisa completar o seu cadastro!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateUser()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'Prosseguir',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Algo errado!');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(15),
                                    child: CircleAvatar(radius: 60),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomDataField(
                                        field: 'Nome',
                                        data:
                                            "${snapshot.data!['firstName']} ${snapshot.data!['lastName']}",
                                      ),
                                      SizedBox(height: 10),
                                      CustomDataField(
                                        field: 'Idade',
                                        data: '${snapshot.data!['age']} anos',
                                      ),
                                      SizedBox(height: 10),
                                      CustomDataField(
                                        field: 'Peso',
                                        data: '${snapshot.data!['weight']} kg',
                                      ),
                                      SizedBox(height: 10),
                                      CustomDataField(
                                        field: 'Altura',
                                        data: '${snapshot.data!['height']} cm',
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    }),
              ),
              SizedBox(height: 10),
              Expanded(
                  child: PageView(
                onPageChanged: (v) {
                  setState(() {
                    selectedIndex = v;
                  });
                },
                controller: _pageController,
                children: [
                  HomeTab(),
                  Container(
                    color: Colors.black,
                  ),
                  Container(
                    color: Colors.white,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDataField extends StatelessWidget {
  final String field;
  final String data;
  const CustomDataField({Key? key, required this.field, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 65,
          child: Text('$field: ',
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
        Text(
          data,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
