import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  String _infoText = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple,
          ),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(firebaseUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data?.data() == null) {
                  return Center();
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
                  
                  double weight = (snapshot.data!['weight']);
                  double height = (snapshot.data!['height']) / 100;
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

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IMC: ${imc.toStringAsPrecision(4)}',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Text(
                          _infoText,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple,
          ),
        ),
      ],
    );
  }
}
