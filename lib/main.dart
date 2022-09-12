import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/services/auth_service.dart';
import 'package:workout_app/views/bar_chart.dart';
import 'package:workout_app/widgets/auth_check.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final uid = FirebaseFirestore.instance
  //     .collection("users")
  //     .doc(FirebaseAuth.instance.currentUser?.uid);
  // final docSnap = await uid.get();
  // final uuid = docSnap.data();
  // if (uuid != null) {
  //   print(uuid);
  // } else {
  //   print('Nada encontrado!');
  // }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        errorColor: Colors.white,
        primarySwatch: Colors.purple,
      ),
      home: const AuthCheck(),
    );
  }
}
