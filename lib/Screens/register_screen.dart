import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/Screens/home_screen.dart';
import 'package:firebase/Screens/constants.dart';
import 'package:firebase/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase/Screens/button.dart';
import 'package:image_picker/image_picker.dart';
// import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String name = '';
  String password = '';
  bool isloading = false;

  File? _imageFile = null;
  final picker = ImagePicker();
  String downloadImageUrl = '';

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('profileImage/$_imageFile!.path)}');
    UploadTask uploadTask = reference.putFile(_imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    downloadImageUrl = await snapshot.ref.getDownloadURL();
    print(downloadImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: _imageFile != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(downloadImageUrl))
                                  : FlatButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                      onPressed: pickImage,
                                    ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                name = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter name'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter email'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your Email',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                              },
                              onChanged: (value) {
                                password = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Choose a Password',
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  )),
                            ),
                            SizedBox(height: 80),
                            LoginSignupButton(
                              title: 'Register',
                              ontapp: () {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection('UserData')
                                          .doc(value.user!.uid)
                                          .set({
                                        "id": value.user!.uid,
                                        "email": email,
                                        "name": name,
                                        "password": password,
                                        "image": downloadImageUrl
                                      });
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.blueGrey,
                                        content: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Sucessfully Register'),
                                        ),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FirstScreen()),
                                    );
                                    setState(() {
                                      isloading = false;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title:
                                            Text(' Ops! Registration Failed'),
                                        content: Text('${e.message}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text('Okay'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
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
