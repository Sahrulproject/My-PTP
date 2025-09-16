import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const CoursesPage(),
    const AttendancePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Home'
              : _selectedIndex == 1
              ? 'Courses'
              : _selectedIndex == 2
              ? 'Attendance'
              : 'Profile',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Muhammad Sahrul Hakim',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'sahrulhakim15@gmail.com',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('My Courses'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// Home Page Content
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'What would you like to learn today?',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Featured Courses
          const Text(
            'Featured Courses',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CourseCard(
                  title: 'Mobile Development',
                  instructor: 'Habibie',
                  rating: 4.8,
                  students: 1250,
                  image: 'assets/images/flutter.png',
                ),
                CourseCard(
                  title: 'Web Development',
                  instructor: 'John Doe',
                  rating: 4.6,
                  students: 980,
                  image: 'assets/images/web.png',
                ),
                CourseCard(
                  title: 'UI/UX Design',
                  instructor: 'Alice Johnson',
                  rating: 4.9,
                  students: 1560,
                  image: 'assets/images/design.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Categories
          const Text(
            'Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
            children: [
              CategoryCard(
                title: 'Programming',
                icon: Icons.code,
                color: Colors.blue,
              ),
              CategoryCard(
                title: 'Design',
                icon: Icons.design_services,
                color: Colors.purple,
              ),
              CategoryCard(
                title: 'Business',
                icon: Icons.business,
                color: Colors.green,
              ),
              CategoryCard(
                title: 'Marketing',
                icon: Icons.trending_up,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Courses Page Content
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('My Courses Page', style: TextStyle(fontSize: 24)),
    );
  }
}

// Attendance Page Content
class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      date: DateTime(2024, 1, 15),
      status: 'Present',
      time: '08:00',
    ),
    AttendanceRecord(
      date: DateTime(2024, 1, 16),
      status: 'Present',
      time: '08:05',
    ),
    AttendanceRecord(
      date: DateTime(2024, 1, 17),
      status: 'Late',
      time: '08:45',
    ),
    AttendanceRecord(date: DateTime(2024, 1, 18), status: 'Absent', time: '-'),
    AttendanceRecord(
      date: DateTime(2024, 1, 19),
      status: 'Present',
      time: '08:02',
    ),
  ];

  bool canCheckIn = true;
  DateTime lastCheckIn = DateTime.now().subtract(const Duration(hours: 5));

  void checkIn() {
    setState(() {
      final now = DateTime.now();
      attendanceRecords.insert(
        0,
        AttendanceRecord(
          date: now,
          status: now.hour > 8 ? 'Late' : 'Present',
          time: '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        ),
      );
      canCheckIn = false;
      lastCheckIn = now;
    });

    // Reset check-in ability after 4 hours
    Future.delayed(const Duration(hours: 4), () {
      if (mounted) {
        setState(() {
          canCheckIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Check-in Button
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Today\'s Attendance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: canCheckIn ? checkIn : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canCheckIn ? Colors.green : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      canCheckIn ? 'CHECK IN' : 'ALREADY CHECKED IN',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  if (!canCheckIn) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Last check-in: ${DateFormat('HH:mm').format(lastCheckIn)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Attendance History
          const Text(
            'Attendance History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = attendanceRecords[index];
              return AttendanceListItem(record: record);
            },
          ),
        ],
      ),
    );
  }
}

// Profile Page Content
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page', style: TextStyle(fontSize: 24)),
    );
  }
}

// Course Card Widget
class CourseCard extends StatelessWidget {
  final String title;
  final String instructor;
  final double rating;
  final int students;
  final String image;

  const CourseCard({
    super.key,
    required this.title,
    required this.instructor,
    required this.rating,
    required this.students,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.blue[100],
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'By $instructor',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString()),
                    const SizedBox(width: 16),
                    const Icon(Icons.people, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text('$students students'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Category Card Widget
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Attendance Record Model
class AttendanceRecord {
  final DateTime date;
  final String status;
  final String time;

  AttendanceRecord({
    required this.date,
    required this.status,
    required this.time,
  });
}

// Attendance List Item Widget
class AttendanceListItem extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (record.status) {
      case 'Present':
        statusColor = Colors.green;
        break;
      case 'Late':
        statusColor = Colors.orange;
        break;
      case 'Absent':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(
            record.status == 'Present'
                ? Icons.check_circle
                : record.status == 'Late'
                ? Icons.access_time
                : Icons.cancel,
            color: statusColor,
          ),
        ),
        title: Text(DateFormat('EEEE, MMMM d, y').format(record.date)),
        subtitle: Text('Time: ${record.time}'),
        trailing: Chip(
          label: Text(
            record.status,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: statusColor,
        ),
      ),
    );
  }
}
