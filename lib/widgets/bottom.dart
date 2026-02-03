import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex; //which tab is active
  final ValueChanged<int> onItemTapped; //callback for when a tab is tapped

  const BottomMenu({
    super.key,
    required this.currentIndex, // which tab is active
    required this.onItemTapped, // callback for when a tab is tapped
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration_outlined),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            label: 'Blank Pages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 22, 77, 29),
        backgroundColor: const Color.fromARGB(255, 105, 138, 108),
        unselectedItemColor: const Color.fromARGB(255, 132, 202, 132),
        type: BottomNavigationBarType.fixed);
  }
}
