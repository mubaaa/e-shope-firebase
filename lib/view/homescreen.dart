import 'package:nikke_e_shope/view/bottomNav/bottomnav.dart';
import 'package:nikke_e_shope/view/bottomNav/newhome.dart';
import 'package:nikke_e_shope/view/bottomNav/profile.dart';
import 'package:nikke_e_shope/view/bottomNav/search.dart';
import 'package:nikke_e_shope/view/bottomNav/saved.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = [
    const NewHomeTab(),
    const SearchTab(),
    const SavedTab(),
    const ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      body: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, child) {
          return _pages[updatedIndex];
        },
      ),
    );
  }
}
