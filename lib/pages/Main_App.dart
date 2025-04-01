import 'package:barscan/pages/MainApp/history_screen.dart';
import 'package:barscan/pages/MainApp/home_screen.dart';
import 'package:barscan/pages/MainApp/profile_screen.dart';
import 'package:barscan/pages/MainApp/scan_screen.dart';
import 'package:barscan/pages/MainApp/search_screen.dart';
// import 'package:flutter/material.dart';

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   _MainAppState createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   int _selectedIndex = 1; // Default to Barcode Scanner

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const ScanScreen(), // Barcode Scanner (Initial)
//     const HistoryScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: "Scan"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.black,
//         showUnselectedLabels: true,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1; // Default to Scan Screen

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScanScreen(),
    const SearchScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Scan"),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      //     BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      //   selectedLabelStyle: const TextStyle(
      //     fontWeight: FontWeight.bold,
      //     fontSize: 14,
      //     backgroundColor: Color.fromARGB(255, 235, 78, 5)
      //   ),
        
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: true,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.black,
      //   backgroundColor: Colors.white,
      //   elevation: 10,
      //   selectedFontSize: 14,
      //   unselectedFontSize: 12,
      //   selectedIconTheme: const IconThemeData(color: Colors.black),
        
      //   unselectedIconTheme: const IconThemeData(color: Colors.black),
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: List.generate(5, (index) {
              bool isActive = _selectedIndex == index;
              return BottomNavigationBarItem(
                icon: Container(
                  
                  decoration: BoxDecoration(
                    
                    color: isActive ? Colors.orange : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Icon(
                    [
                      Icons.home,
                      Icons.camera_alt,
                      Icons.search,
                      Icons.history,
                      Icons.person
                    ][index],
                    color: isActive ? Colors.black : Colors.black54,
                  ),
                ),
                label: [
                  "Home",
                  "Scan",
                  "Search",
                  "History",
                  "Profile"
                ][index],
              );
            }),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            elevation: 10,
          ),
        ),
      ),
    );
  }
}

