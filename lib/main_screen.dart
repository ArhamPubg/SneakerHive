// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:sneakerhive/Widgets/carasolwidget.dart';
import 'package:sneakerhive/Widgets/productwidget.dart';
import 'package:sneakerhive/Widgets/textwidget.dart';
import 'package:sneakerhive/favourite_screen.dart';
import 'package:sneakerhive/sign_up_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> items = ["All", "Popular", "Mens", "Women"];

  int current = 0;

  String isclicked = '';

  CarasolSliderWidget carasol = const CarasolSliderWidget();

  bool isloading = false;
  @override
  void initState() {
    isloading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  bool priceorder = false;

  void logout() async {
    try {
      setState(() {});
      await FirebaseAuth.instance.signOut();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()));
      Fluttertoast.showToast(msg: 'Successfully Logout');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error logging out: $e');
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: GoogleFonts.cabin(
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.5),
            child: Container(
                height: 40,
                width: 37,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouriteScreen()));
                  },
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.cart,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
        ],
        leadingWidth: 70,
        leading: user != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: InkWell(
                      onTap: () {
                        logout();
                      },
                      child: Center(
                        child: TextWidget(
                            text: 'Logout',
                            fontWeight: FontWeight.bold,
                            size: 12,
                            color: Colors.white),
                      )),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen())),
                    child: const Icon(
                      CupertinoIcons.person,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
      body: isloading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SizedBox(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: GestureDetector(
                              onTap: () {},
                              child: TextField(
                                autocorrect: true,
                                cursorOpacityAnimates: true,
                                cursorColor: Colors.black,
                                style: GoogleFonts.cabin(),
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.search,
                                    fill: 1,
                                  ),
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.cabin(
                                      textStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis)),
                                  contentPadding: const EdgeInsets.only(
                                      top: 10,
                                      left: 15), // Adjust the top padding here
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isclicked = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        LoadingBtn(
                          height: 49,
                          borderRadius: 8,
                          animate: true,
                          color: Colors.black,
                          width: 48,
                          loader: Container(
                            padding: const EdgeInsets.all(10),
                            width: 47,
                            height: 49,
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          child: Container(
                            height: 47,
                            width: 49,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.filter_list,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (btnState == ButtonState.idle) {
                              startLoading();
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              stopLoading();

                              showMenu(
                                  context: context,
                                  position:
                                      const RelativeRect.fromLTRB(100, 0, 0, 0),
                                  items: <PopupMenuItem<List>>[
                                    PopupMenuItem(
                                      child: Text(priceorder
                                          ? 'Low to High'
                                          : 'High to Low'),
                                      onTap: () {
                                        setState(() {
                                          priceorder = true;
                                        });
                                      },
                                    )
                                  ]);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(height: 160, child: carasol),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          current = index;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.all(5),
                                        width: 100,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: current == index
                                              ? BorderRadius.circular(12)
                                              : BorderRadius.circular(7),
                                          border: current == index
                                              ? Border.all(
                                                  color: Colors.black,
                                                  width: 2.5)
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            items[index],
                                            style: GoogleFonts.cabin(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                    visible: current == index,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      items[current],
                      style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProductWidget(
                    search: isclicked,
                    category: items[current],
                    orderprice: priceorder,
                  )
                ],
              ),
            ),
    );
  }
}
