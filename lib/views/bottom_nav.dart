import 'package:flutter/material.dart';
import 'package:myptp/views/history_screen.dart';
import 'package:myptp/views/home_screen.dart';
import 'package:myptp/views/izin_screen.dart';
import 'package:myptp/views/presence_screen.dart';
import 'package:myptp/views/profile_screen.dart';

class ButtomPage extends StatefulWidget {
  const ButtomPage({super.key});
  static const id = "/buttom_page";

  @override
  State<ButtomPage> createState() => _ButtomPageState();
}

class _ButtomPageState extends State<ButtomPage> {
  List<Widget> screens = [
    HomeScreen(),
    HistoryScreen(),
    PresenceScreen(),
    IzinScreen(),
    ProfileScreen(),
  ];

  int currentIndex = 0;

  void nextPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentIndex = 2;
            });
            // context.pushNamed(PresenceScreen.id);
          },
          child: Image.asset(
            "assets/images/Attendance.png",
            width: 30,
            height: 30,
          ),
          backgroundColor: Color(0xFF1E3A8A),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              0,
              active: "assets/images/home 2.png",
              inactive: "assets/images/home 1.png",
            ),
            _navItem(
              1,
              active: "assets/images/history 2.png",
              inactive: "assets/images/history 1.png",
            ),
            const SizedBox(width: 48),
            _navItem(
              3,
              active: "assets/images/izin 2.png",
              inactive: "assets/images/izin 1.png",
            ),
            _navItem(
              4,
              active: "assets/images/profile 2.png",
              inactive: "assets/images/profile 1.png",
            ),
          ],
        ),
      ),
      body: IndexedStack(index: currentIndex, children: screens),
    );
  }

  Widget _navItem(
    int index, {
    required String active,
    required String inactive,
  }) {
    return IconButton(
      onPressed: () => nextPage(index),
      icon: Image.asset(
        currentIndex == index ? active : inactive,
        width: 25,
        height: 25,
      ),
    );
  }
}
