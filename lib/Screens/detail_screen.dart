import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneakerhive/Manager/favouriteManager.dart';

class ShoesDetailScreen extends StatefulWidget {
  final dynamic image;
  final dynamic title;
  final dynamic price;
  final dynamic desc;
  final dynamic productId;

  ShoesDetailScreen(
      {super.key,
      this.image,
      this.title,
      this.price,
      this.desc,
      this.productId});

  @override
  State<ShoesDetailScreen> createState() => _ShoesDetailScreenState();
}

class _ShoesDetailScreenState extends State<ShoesDetailScreen> {
  int current = 0;
  bool isclicked = false;
  bool onFavTap = false;

  List<String> sizeNumber = ['40', '41', '42', '43'];
  double stars = 5;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    onFavTap = await FavoriteManager.getFavoriteStatus(widget.productId);
    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    if (user == null) {
      showToast(
        "Guest can't Favourite an item",
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    } else if (user != null && !onFavTap) {
      setState(() {
        onFavTap = true;
      });
      await FavoriteManager.setFavoriteStatus(widget.productId, onFavTap);

      showToast(
        "Item Added to your WishList",
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      await _addProductToFavorites(widget.productId);
    } else {
      setState(() {
        onFavTap = false;
      });

      await FavoriteManager.setFavoriteStatus(widget.productId, onFavTap);

      showToast(
        "Item Removed from your WishList",
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fadeScale,
        position: StyledToastPosition.top,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      await _removeProductFromFavorites(widget.productId);
    }
  }

  Future<void> _addProductToFavorites(String productId) async {
    await FirebaseFirestore.instance
        .collection('UserAuth')
        .doc(user!.uid)
        .collection('VendorFavProducts')
        .doc(productId)
        .set({'productId': productId});
  }

  Future<void> _removeProductFromFavorites(String productId) async {
    await FirebaseFirestore.instance
        .collection('UserAuth')
        .doc(user!.uid)
        .collection('VendorFavProducts')
        .doc(productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: _toggleFavorite,
              child: Icon(
                user != null
                    ? onFavTap
                        ? CupertinoIcons.heart_solid
                        : CupertinoIcons.heart
                    : CupertinoIcons.heart,
                color: user != null
                    ? onFavTap
                        ? Colors.red
                        : Colors.black
                    : null,
                size: 25,
              ),
            ),
          )
        ],
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
                      stars.toString(),
                      style: GoogleFonts.cabin(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    RatingBar.builder(
                      itemSize: 17,
                      initialRating: stars,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          stars = rating;
                        });
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
                      // Add to cart logic here
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
