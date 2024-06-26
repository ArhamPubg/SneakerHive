import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouriteScreen extends StatefulWidget {
  final String? productId;
  final bool? isclicked;
  const FavouriteScreen({Key? key, this.productId, this.isclicked})
      : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool isloading = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isloading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'No Item in WishList',
            style: GoogleFonts.cabin(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: widget.isclicked == true ? true : false,
        title: Text(
          'Favourites',
          style: GoogleFonts.cabin(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchProductsByUserId(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
                  return const Center(child: Text('An error occurred.'));
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No Item in WishList',
                      style: GoogleFonts.cabin(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  );
                }

                List<Map<String, dynamic>> data = snapshot.data!;

                return GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 245,
                  ),
                  itemBuilder: (context, index) {
                    var productData = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Transform.rotate(
                                  angle: 12,
                                  child: Image.network(productData['image']),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    productData['title'],
                                    style: GoogleFonts.cabin(
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 13, top: 3),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '\$${productData['price']}',
                                    style: GoogleFonts.cabin(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchProductsByUserId(
      String userId) async {
    List<Map<String, dynamic>> products = [];
    try {
      QuerySnapshot userProductReference = await FirebaseFirestore.instance
          .collection('UserAuth')
          .doc(userId)
          .collection('VendorFavProducts')
          .get();

      for (var userproductId in userProductReference.docs) {
        DocumentSnapshot reference = await FirebaseFirestore.instance
            .collection('Products')
            .doc(userproductId['productId'])
            .get();

        if (reference.exists) {
          products.add(reference.data() as Map<String, dynamic>);
        }
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: 'Error : $e');
    }

    return products;
  }

  Future<void> deleteProductIds(productId, user) async {
    await FirebaseFirestore.instance
        .collection('UserAuth')
        .doc(user)
        .collection('VendorFavProducts')
        .doc(productId)
        .delete();
  }
}
