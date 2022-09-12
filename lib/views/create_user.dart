import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_app/services/auth_service.dart';
import 'package:workout_app/views/home_page.dart';
import 'package:workout_app/widgets/custom_textfield.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final authService = AuthService();
  DateTime _selectedDate = DateTime.now();
  bool isImagePicked = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  XFile? _image;

  File? file;

  String downloadUrl = '';

  Future getImage() async {
    ImagePicker picker = ImagePicker();

    _image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (_image != null) {
        setState(() {
          isImagePicked = true;
        });
        file = File(_image!.path);
        uploadFile();
      } else {
        setState(() {
          isImagePicked = false;
        });
      }
    });
  }

  Future<void> uploadFile() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('userImages')
        .child(firebaseUser!.uid)
        .putFile(file!);

    TaskSnapshot s = await uploadTask;
    downloadUrl = await s.ref.getDownloadURL();
    setState(() {});
  }

  // _showDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now(),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   });
  // }

  Future<void> save(Map<String, dynamic> userData) async {
    setState(() => loading = true);
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser!.uid)
          .set(userData);
    } on AuthException catch (error) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        color: Colors.purple.withOpacity(.5),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      height: 200,
                      width: 200,
                      child: isImagePicked
                          ? ClipRRect(
                              child: downloadUrl == ''
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Image.network(
                                      downloadUrl,
                                      fit: BoxFit.cover,
                                    ),
                              borderRadius: BorderRadius.circular(100),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 50),
                                  Text('Escolha uma imagem')
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  validator: (v) {
                    if (v!.length < 3) {
                      return 'Digite seu primeiro nome!';
                    }
                  },
                  controller: _firstNameController,
                  obscure: false,
                  hint: 'Ex: Fulano',
                  label: 'Nome',
                ),
                SizedBox(height: 20),
                CustomTextField(
                  validator: (v) {
                    if (v!.length < 3) {
                      return 'Digite seu sobrenome!';
                    }
                  },
                  controller: _lastNameController,
                  obscure: false,
                  hint: 'Ex: Almeida',
                  label: 'Sobrenome',
                ),
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.numberWithOptions(),
                  validator: (v) {},
                  controller: _ageController,
                  obscure: false,
                  hint: 'Ex: 20',
                  label: 'Idade',
                ),
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.numberWithOptions(),
                  validator: (v) {},
                  controller: _weightController,
                  obscure: false,
                  hint: 'Ex: 80',
                  label: 'Peso',
                ),
                SizedBox(height: 20),
                CustomTextField(
                  inputType: TextInputType.numberWithOptions(),
                  validator: (v) {},
                  controller: _heightController,
                  obscure: false,
                  hint: 'Ex: 170',
                  label: 'Altura',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        (isImagePicked == true)) {
                      Map<String, dynamic> userData = {
                        "imageUrl": downloadUrl,
                        "firstName": _firstNameController.text,
                        "lastName": _lastNameController.text,
                        "age": int.parse(_ageController.text),
                        "weight": double.parse(_weightController.text),
                        "height": double.parse(_heightController.text),
                      };
                      save(userData);
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      });
                    }
                  },
                  child: loading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
