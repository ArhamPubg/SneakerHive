import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sneakerhive/favourite_screen.dart';
import 'package:sneakerhive/main_screen.dart';

class BottamBar extends StatefulWidget {
  const BottamBar({Key? key}) : super(key: key);

  @override
  State<BottamBar> createState() => _BottamBarState();
}

class _BottamBarState extends State<BottamBar> {
  int currentIndex = 0;

  List<Widget> pages = [
    const MainScreen(),
    FavouriteScreen(), // Ensure this screen handles null safely
    FavouriteScreen(), // Duplicate for demo purposes
    FavouriteScreen(), // Duplicate for demo purposes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.home),
            title: const Text("Home"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.shopping_cart),
            title: const Text("Shop"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.heart),
            title: const Text("Favourite"),
            selectedColor: Colors.black,
          ),
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.person),
            title: const Text("Profile"),
            selectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
