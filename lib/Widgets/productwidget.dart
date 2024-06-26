import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneakerhive/Screens/detail_screen.dart';

class ProductWidget extends StatefulWidget {
  final String search;
  final dynamic category;
  final dynamic orderprice;
  const ProductWidget(
      {super.key, required this.search, this.category, this.orderprice});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Products')
          .where('category', isEqualTo: widget.category.toString())
          .where('title', isGreaterThanOrEqualTo: widget.search)
          .where('title', isLessThanOrEqualTo: '${widget.search}\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CupertinoActivityIndicator(
            color: Colors.black,
          ));
        } else if (snapshot.hasError) {
          Fluttertoast.showToast(msg: 'Error : ${snapshot.error}');
          return Center(
              child:
                  Text('Error loading products', style: GoogleFonts.cabin()));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Products found',
              style: GoogleFonts.cabin(),
            ),
          );
        }

        var data = snapshot.data!.docs;
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            mainAxisExtent: 255,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => ShoesDetailScreen(
                          image: data[index]['image'],
                          title: data[index]['title'],
                          price: data[index]['price'],
                          desc: data[index]['description'],
                          productId: data[index]['productId']),
                    ),
                  );
                },
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
                          child: Image.network(
                            data[index]['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data[index]['title'],
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
                        padding: const EdgeInsets.only(left: 13, top: 3),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\$${data[index]['price']}',
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
    );
  }
}
