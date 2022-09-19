import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int? age;
  String? firstName;
  String? lastName;
  double? height;
  double? weight;
  String? imageUrl;
  UserModel({
    this.age,
    this.firstName,
    this.lastName,
    this.height,
    this.weight,
    this.imageUrl,
  });

  UserModel.fromDocument(DocumentSnapshot snapshot) {
    age = snapshot["age"];
    firstName = snapshot["firstName"];
    lastName = snapshot["lastName"];
    height = snapshot["height"];
    weight = snapshot["weight"];
    imageUrl = snapshot["imageUrl"];
  }
}
