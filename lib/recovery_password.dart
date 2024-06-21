import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sneakerhive/Widgets/authentication_widgets.dart';
import 'package:sneakerhive/Widgets/textwidget.dart';
import 'package:sneakerhive/signin.dart';

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({super.key});

  @override
  State<RecoveryPassword> createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  final TextEditingController _controller1 = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: !isLoading
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('auth_data')
                    .doc('recoverypassword')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data available'));
                  }

                  // Safely extract the data
                  final data = snapshot.data!;
                  final title = data['title'] ?? 'Title not available';
                  final subtitle = data['subtitle'] ?? 'Subtitle not available';
                  final email = data['email'] ?? 'Email not available';
                  final buttonText = data['button'] ?? 'Button not available';

                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Center(
                            child: TextWidget(
                                text: title,
                                fontWeight: FontWeight.bold,
                                size: 30,
                                color: Colors.white)),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Center(
                              child: TextWidget(
                                  text: subtitle,
                                  fontWeight: FontWeight.w400,
                                  size: 16,
                                  color: Colors.white)),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 20),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                  text: email,
                                  fontWeight: FontWeight.w700,
                                  size: 17,
                                  color: Colors.white)),
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                            height: 52,
                            width: 372,
                            child: UserTextField(
                                controller: _controller1,
                                error: 'Please enter your Email')),
                        Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: Button(
                              buttonbackgroundcolor: Colors.white,
                              buttonforebackgroundcolor: Colors.black,
                              button: buttonText,
                              size: 20,
                              textweight: FontWeight.w600,
                              textcolor: Colors.black,
                              ontap: () async {
                                if (_controller1.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: 'Please enter your email address',
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await auth
                                      .sendPasswordResetEmail(
                                          email: _controller1.text.trim())
                                      .then((value) {
                                    Fluttertoast.showToast(
                                      msg:
                                          'Password reset email sent. Check your email for further instructions.',
                                    );

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen(),
                                      ),
                                    );
                                  });
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Fluttertoast.showToast(msg: 'Error: $e');
                                }
                              },
                            )),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
