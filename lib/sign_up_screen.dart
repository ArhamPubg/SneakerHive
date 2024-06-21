import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneakerhive/Model/user_model.dart';
import 'package:sneakerhive/Widgets/authentication_widgets.dart';
import 'package:sneakerhive/Widgets/textwidget.dart';
import 'package:sneakerhive/signin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode node1 = FocusNode();
  final FocusNode node2 = FocusNode();
  final FocusNode node3 = FocusNode();

  bool tap = false;
  bool isLoading = false;
  bool isClicked = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    node1.dispose();
    node2.dispose();
    node3.dispose();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  signup(email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await postDatatoFirebase();
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error : $e');
    }
  }

  Future<void> postDatatoFirebase() async {
    final usermodel = UserModel();
    usermodel.email = _auth.currentUser!.email ?? '';
    usermodel.name = nameController.text;
    usermodel.password = _auth.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('UserAuth')
        .doc(_auth.currentUser!.uid)
        .set(usermodel.toJson());

    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
              color: Colors.white,
            ))
          : SingleChildScrollView(
              child: Form(
                  key: formKey,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('auth_data')
                        .doc('SignUpSystem')
                        .snapshots(),
                    builder: (context, userDataSnapshot) {
                      if (userDataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userDataSnapshot.hasError) {
                        Fluttertoast.showToast(
                            msg: 'Error : ${userDataSnapshot.error}');
                        return Container(); // Handle error case
                      }
                      if (!userDataSnapshot.hasData) {
                        return const Center(child: Text('No Data Found'));
                      }

                      final userData = userDataSnapshot.data!;

                      return Column(
                        children: [
                          Center(
                              child: TextWidget(
                                  text: userData['title'],
                                  fontWeight: FontWeight.bold,
                                  size: 30,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Center(
                              child: TextWidget(
                                  text: userData['subtitle'],
                                  fontWeight: FontWeight.w400,
                                  size: 19,
                                  color: Colors.white)),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                    text: userData['name'],
                                    fontWeight: FontWeight.w700,
                                    size: 18,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 8),
                          UserTextField(
                              node: node1,
                              controller: nameController,
                              error: 'Please enter your Name'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                    text: userData['email'],
                                    fontWeight: FontWeight.w700,
                                    size: 18,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 8),
                          UserTextField(
                              node: node2,
                              controller: emailController,
                              error: 'Please enter your Email'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                    text: userData['password'],
                                    fontWeight: FontWeight.w700,
                                    size: 18,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 8),
                          UserPassTextField(
                              isclicked: isClicked,
                              node: node3,
                              controller: passwordController,
                              error: 'Please enter your Password'),
                          Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await signup(emailController.text,
                                      passwordController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                fixedSize:
                                    const Size(340, 50), // Set height and width
                              ),
                              child: Text(userData['button'],
                                  style: GoogleFonts.cabin(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                    text: userData['account'],
                                    fontWeight: FontWeight.w300,
                                    size: 14,
                                    color: Colors.white),
                                const SizedBox(width: 3),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInScreen()),
                                      );
                                    },
                                    child: TextWidget(
                                        text: userData['signin'],
                                        fontWeight: FontWeight.w300,
                                        size: 14,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
    );
  }
}
