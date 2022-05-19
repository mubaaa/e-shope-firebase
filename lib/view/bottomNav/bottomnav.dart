import 'package:nikke_e_shope/constant/color.dart';
import 'package:nikke_e_shope/view/homescreen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
        valueListenable: HomeScreen.selectedIndexNotifier,
        builder: (context, int updatedIndex, Widget? _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                currentIndex = index;
                HomeScreen.selectedIndexNotifier.value = currentIndex;
              });
            },
            currentIndex: currentIndex,
            backgroundColor: Colors.white,
            selectedItemColor: primarycolor,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.green),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  label: 'Favourite',
                  backgroundColor: Colors.green),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue,
              ),
            ],
          );
          
        });
  }
}
