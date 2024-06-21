import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Map<String, dynamic>> history = [];

  final box = Hive.box('favbox');
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    isloading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isloading = false;
      });
    });
    _refreshhistory();
  }

  void _refreshhistory() {
    final data = box.keys.map((key) {
      final value = box.get(key);
      return {
        "key": key,
        "image": value["image"],
        "title": value["title"],
        "price": value["price"]
      };
    }).toList();
    setState(() {
      history = data.reversed.toList();
    });
  }

  Future<void> _deletevalue(key) async {
    await box.delete(key);
    _refreshhistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'Favourites',
          style: GoogleFonts.cabin(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: history.isEmpty
          ? isloading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Center(
                  child: Text(
                    'No Product Found',
                    style: GoogleFonts.cabin(
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        fontSize: 22),
                  ),
                )
          : isloading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: history.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 245,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 130,
                                    top: 12,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await _deletevalue(
                                            history[index]['key']);
                                      },
                                      child: Icon(
                                        CupertinoIcons.clear,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18),
                                        child: Transform.rotate(
                                          angle: 12,
                                          child: Image.network(
                                              history[index]['image']),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            history[index]['title'],
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
                                        padding: const EdgeInsets.only(
                                            left: 13, top: 3),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '\$${history[index]['price']}',
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
