import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_btn/loading_btn.dart';

class CarasolSliderWidget extends StatefulWidget {
  const CarasolSliderWidget({super.key});

  @override
  State<CarasolSliderWidget> createState() => _CarasolSliderWidgetState();
}

class _CarasolSliderWidgetState extends State<CarasolSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return const Center(child: Text('Error loading products'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Products Found'));
        }

        var data = snapshot.data!.docs;

        return CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: const BouncingScrollPhysics(),
            height: 150,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 300),
            viewportFraction: 0.8,
          ),
          items: data.map((doc) {
            var product = doc.data();
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffF6F6F6),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                        width: MediaQuery.of(context).size.width / 2.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['title'],
                                style: GoogleFonts.cabin(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                )),
                            const SizedBox(
                              height: 3,
                            ),
                            Text('\$${product['price']}',
                                style: GoogleFonts.cabin(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            LoadingBtn(
                              height: 37,
                              borderRadius: 8,
                              animate: true,
                              color: Colors.black,
                              width: MediaQuery.of(context).size.width / 4,
                              loader: Container(
                                padding: const EdgeInsets.all(10),
                                width: 40,
                                height: 40,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              child: Text('Shop Now',
                                  style: GoogleFonts.cabin(
                                    textStyle: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )),
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                if (btnState == ButtonState.idle) {
                                  startLoading();
                                  // call your network api
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                  stopLoading();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Transform.rotate(
                        angle: 12,
                        child: Image.network(
                          product['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
