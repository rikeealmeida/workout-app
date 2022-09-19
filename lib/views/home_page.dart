import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/user_model.dart';
import 'package:workout_app/services/auth_service.dart';
import 'package:workout_app/views/bar_chart.dart';
import 'package:workout_app/views/create_user.dart';
import 'package:workout_app/views/edit_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();
  int selectedIndex = 0;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  String _infoText = '';

  dynamic uuid;
  Future checkRegistry() async {
    final uid =
        FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid);
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
      backgroundColor: Colors.purple,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.purple),
        tooltip: 'Add Registry',
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
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(.5),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(color: Colors.purple),
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
                                    Navigator.of(context).push(
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
                        UserModel user = UserModel.fromDocument(snapshot.data!);
                        double weight = user.weight!;
                        double height = user.height! / 100;
                        double imc = weight / (height * height);
                        if (imc < 18.6) {
                          _infoText = "Abaixo do Peso";
                        } else if (imc >= 18.6 && imc < 24.9) {
                          _infoText = "Peso Ideal)";
                        } else if (imc >= 24.9 && imc < 29.9) {
                          _infoText = "Levemente Acima do Peso";
                        } else if (imc >= 29.9 && imc < 34.9) {
                          _infoText = "Obesidade Grau I";
                        } else if (imc >= 34.9 && imc < 39.9) {
                          _infoText = "Obesidade Grau II";
                        } else if (imc >= 40) {
                          _infoText = "Obesidade Grau III";
                        }
                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.purple.shade800,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: user.imageUrl != ''
                                            ? ClipRRect(
                                                child: Image.network(
                                                  user.imageUrl!,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: 30,
                                              ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDataField(
                                          field: 'Nome',
                                          data:
                                              "${user.firstName} ${user.lastName}",
                                        ),
                                        SizedBox(height: 10),
                                        CustomDataField(
                                          field: 'Idade',
                                          data: '${user.age} anos',
                                        ),
                                        SizedBox(height: 10),
                                        CustomDataField(
                                          field: 'Peso',
                                          data: '${user.weight} kg',
                                        ),
                                        SizedBox(height: 10),
                                        CustomDataField(
                                          field: 'Altura',
                                          data: '${user.height} cm',
                                        ),
                                        SizedBox(height: 10),
                                        CustomDataField(
                                            field: 'IMC',
                                            data:
                                                '${imc.toStringAsPrecision(4)}'),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${_infoText}!",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => const EditUser(),
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.purple,
                                            size: 18,
                                          ),
                                          SizedBox(width: 3),
                                          Text('Editar dados',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.purple)),
                                        ],
                                      ),
                                    ),
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(30))),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BarChartSample1(),
                      ),
                    ],
                  ),
                ),
              )
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
