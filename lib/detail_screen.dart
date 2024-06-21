import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class ShoesDetailScreen extends StatefulWidget {
  dynamic image;
  dynamic title;
  dynamic price;
  dynamic desc;

  ShoesDetailScreen({super.key, this.image, this.title, this.price, this.desc});

  @override
  State<ShoesDetailScreen> createState() => _ShoesDetailScreenState();
}

class _ShoesDetailScreenState extends State<ShoesDetailScreen> {
  int current = 0;
  bool isclicked = false;

  List<String> sizeNumber = ['40', '41', '42', '43'];

  final box = Hive.box('favbox');

  Future<void> storedatatohive(Map<String, dynamic> value) async {
    final existingProduct = box.values.firstWhere(
        (element) =>
            element['title'] == value['title'] &&
            element['price'] == value['price'] &&
            element['title'] == value['title'],
        orElse: () => null);

    if (existingProduct == null) {
      await box.add(value);

      // ignore: use_build_context_synchronously
      showToast(
        'Product will be Added',
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    } else if (existingProduct != null) {
      showToast(
        'Product Already exist in the Cart',
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF6F6F6),
      ),
      backgroundColor: const Color(0xffF6F6F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Transform.rotate(
              angle: 12,
              child: Padding(
                padding: const EdgeInsets.only(right: 70),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 60),
            child: Text(
              widget.title,
              style: GoogleFonts.cabin(
                textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28, top: 12),
                child: Text(
                  '\$${widget.price}',
                  style: GoogleFonts.cabin(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 138, top: 13),
                child: Row(
                  children: [
                    Text(
                      '(5) ',
                      style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    RatingBar.builder(
                      itemSize: 17,
                      initialRating: 5,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) async {
                        FirebaseFirestore.instance
                            .collection('Shoes_Collection')
                            .doc('QV4YgdYUdD57WiRONRqk')
                            .set({'rating': rating});
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 70,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sizeNumber.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 19, top: 10),
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: GlobalKey(),
                          foregroundColor:
                              current == index ? Colors.white : Colors.black,
                          elevation: 0,
                          backgroundColor:
                              current == index ? Colors.black : Colors.white,
                          onPressed: () {
                            setState(() {
                              current = index;
                            });
                            setState(() {
                              isclicked = !isclicked;
                            });
                          },
                          child: Text(
                            sizeNumber[index],
                            style: GoogleFonts.cabin(),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23, top: 14),
            child: Text(
              widget.desc,
              style: GoogleFonts.cabin(
                textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: CupertinoButton(
                  color: Colors.black,
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.cabin(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      showToast(
                        "Guest can't add to cart a Product",
                        context: context,
                        animation: StyledToastAnimation.scale,
                        reverseAnimation: StyledToastAnimation.fadeScale,
                        position: StyledToastPosition.top,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 3),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );
                    } else {
                      await storedatatohive({
                        'image': widget.image,
                        'title': widget.title,
                        'price': widget.price
                      });
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
