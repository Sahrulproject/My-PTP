// import 'package:flutter/material.dart';
// // import 'package:ppkd_b_3/day12/about8.dart';
// // import 'package:ppkd_b_3/day12/draw.dart';

// class NavScreen extends StatefulWidget {
//   const NavScreen({super.key});
//   static const id = "/task";

//   @override
//   State<NavScreen> createState() => _Tugas8State();
// }

// class _Tugas8State extends State<NavScreen> {
//   int _selectedIndex = 0;
//   static const List<Widget> _widgetOptions = <Widget>[
//     // HomeScreen(),
//     // About8(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: _widgetOptions[_selectedIndex]),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             // activeIcon: Icon(Icons.abc_outlined),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info_outline),
//             label: 'About',
//           ),
//           // BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.black,
//         onTap: (value) {
//           print(value);
//           // print("Nilai SelecetedIndex Before : $_selectedIndex");

//           // print("Nilai BotNav : $value");
//           setState(() {
//             _selectedIndex = value;
//           });
//           // print("Nilai SelecetedIndex After: $_selectedIndex");
//         },
//         // onTap: _onItemTapped,
//       ),
//     );
//   }
// }
