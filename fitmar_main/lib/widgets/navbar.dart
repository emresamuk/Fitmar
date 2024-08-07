import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoltenBottomNavigationBar(
      selectedIndex: selectedIndex,
      onTabChange: onTabChange,
      tabs: [
        MoltenTab(icon: const Icon(Icons.home)),
        MoltenTab(icon: const Icon(Icons.food_bank_sharp)),
        MoltenTab(icon: const Icon(Icons.text_snippet)), 
        MoltenTab(icon: const Icon(Icons.person)),
      ],
    );
  }
}
