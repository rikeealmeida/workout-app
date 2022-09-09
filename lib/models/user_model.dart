import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? firstName;
  final String? lastName;
  final double? height;
  final double? weight;
  final String? age;
  UserModel({
    this.firstName,
    this.lastName,
    this.height,
    this.age,
    this.weight,
  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserModel(
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      height: data?['height'],
      age: data?['age'],
      weight: data?['weight'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (height != null) "height": height,
      if (age != null) "age": age,
      if (weight != null) "weight": weight,
    };
  }
}
