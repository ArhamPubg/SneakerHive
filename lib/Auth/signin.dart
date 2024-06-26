import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sneakerhive/Auth/recovery_password.dart';
import 'package:sneakerhive/Screens/main_screen.dart';
import 'package:sneakerhive/Widgets/authentication_widgets.dart';
import 'package:sneakerhive/Widgets/textwidget.dart';
import 'package:sneakerhive/Screens/bottam_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  Future<void> signIn(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(msg: 'Successfully logged in');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottamBar()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error: $e');
    }
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
                        .doc('LoginSystem')
                        .snapshots(),
                    builder: (context, userDataSnapshot) {
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
                                    text: userData['email'],
                                    fontWeight: FontWeight.w700,
                                    size: 18,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 8),
                          UserTextField(
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
                              controller: passwordController,
                              error: 'Please enter your Password'),
                          Padding(
                            padding: const EdgeInsets.only(right: 25, top: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecoveryPassword())),
                                child: TextWidget(
                                    text: userData['recovery_pass'],
                                    fontWeight: FontWeight.bold,
                                    size: 13,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await signIn(emailController.text,
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
                            child: ElevatedButton(
                              onPressed: () async {
                                await loginwithgoogle();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()));

                                Fluttertoast.showToast(
                                    msg: 'Successfully Login with Google');
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                fixedSize:
                                    const Size(340, 50), // Set height and width
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google.png',
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.contain,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(userData['google'],
                                      style: GoogleFonts.cabin(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      )),
                                ],
                              ),
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
                                        text: userData['signup'],
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

Future loginwithgoogle() async {
  try {
    final googleuser = await GoogleSignIn().signIn();

    final googleAuth = await googleuser?.authentication;

    final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth!.idToken, accessToken: googleAuth.accessToken);

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credentials);
    final User? user = userCredential.user;

    // Store user data in Firestore
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('UserAuth')
          .doc(user.uid)
          .set({
        'password': user.uid,
        'name': user.displayName,
        'email': user.email,
      });
    }
  } on UserCredential catch (e) {
    Fluttertoast.showToast(msg: 'Error : $e');
  }
}
