// import 'package:flutter/material.dart';
// import 'package:kholas_absen/view/auth/dashboard.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//   static const id = "/main_page";

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [Dashboard()];

//   void _onItemtapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text("Katering apps")),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             // backgroundColor: Color.fromARGB(255, 255, 255, 255),
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Color.fromARGB(255, 255, 255, 255),
//             icon: Icon(Icons.local_drink),
//             label: 'Business',
//             // backgroundColor: Color.fromARGB(255, 255, 255, 255),
//           ),
//         ],
//         backgroundColor: Color(0xFF0F1B2B),
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemtapped,
//       ),
//     );
//   }
// }
