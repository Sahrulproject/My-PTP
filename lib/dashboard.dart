// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'main.dart';

// // Halaman Dashboard
// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   User? _user;
//   Attendance? _todayAttendance;
//   AttendanceStats? _stats;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadTodayAttendance();
//     _loadStats();
//   }

//   Future<void> _loadUserData() async {
//     // Simulasi mengambil data user
//     final prefs = await SharedPreferences.getInstance();
//     final userData = prefs.getString('user_data');

//     if (userData != null) {
//       setState(() {
//         _user = User.fromJson(json.decode(userData));
//       });
//     }
//   }

//   Future<void> _loadTodayAttendance() async {
//     // Simulasi mengambil data absen hari ini
//     await Future.delayed(Duration(seconds: 1));
//     setState(() {
//       _todayAttendance = Attendance(
//         date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         checkIn: '08:00',
//         checkOut: '17:00',
//         location: 'Jakarta, Indonesia',
//       );
//     });
//   }

//   Future<void> _loadStats() async {
//     // Simulasi mengambil statistik
//     await Future.delayed(Duration(seconds: 1));
//     setState(() {
//       _stats = AttendanceStats(present: 20, late: 2, absent: 3);
//     });
//   }

//   Future<void> _checkIn() async {
//     // Simulasi absen masuk
//     await Future.delayed(Duration(seconds: 1));
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Absen masuk berhasil')));
//     _loadTodayAttendance();
//   }

//   Future<void> _checkOut() async {
//     // Simulasi absen pulang
//     await Future.delayed(Duration(seconds: 1));
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Absen pulang berhasil')));
//     _loadTodayAttendance();
//   }

//   Future<void> _showPermissionDialog() async {
//     String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     String reason = '';

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Ajukan Izin'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Tanggal',
//                 suffixIcon: Icon(Icons.calendar_today),
//               ),
//               onTap: () async {
//                 final DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2025),
//                 );
//                 if (picked != null) {
//                   selectedDate = DateFormat('yyyy-MM-dd').format(picked);
//                 }
//               },
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Alasan'),
//               maxLines: 3,
//               onChanged: (value) {
//                 reason = value;
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Simulasi pengajuan izin
//               Navigator.pop(context);
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text('Izin berhasil diajukan')));
//             },
//             child: Text('Ajukan'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history),
//             onPressed: () {
//               Navigator.pushNamed(context, '/history');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.person),
//             onPressed: () {
//               Navigator.pushNamed(context, '/profile');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool('isLoggedIn', false);
//               await prefs.remove('auth_token');
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
//                   SizedBox(height: 10),
//                   Text(
//                     _user?.name ?? 'Loading...',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   Text(
//                     _user?.email ?? '',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.dashboard),
//               title: Text('Dashboard'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history),
//               title: Text('Riwayat Absensi'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/history');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profil'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool('isLoggedIn', false);
//                 await prefs.remove('auth_token');
//                 Navigator.pushReplacementNamed(context, '/login');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Halo, ${_user?.name ?? ''}',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 5),
//             Text(
//               DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _checkIn,
//                     icon: Icon(Icons.login),
//                     label: Text('Absen Masuk'),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _checkOut,
//                     icon: Icon(Icons.logout),
//                     label: Text('Absen Pulang'),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Status Absensi Hari Ini',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Masuk:'),
//                         Text(_todayAttendance?.checkIn ?? 'Belum absen'),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Pulang:'),
//                         Text(_todayAttendance?.checkOut ?? 'Belum absen'),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Lokasi:'),
//                         Text(_todayAttendance?.location ?? 'Tidak tercatat'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Statistik Absensi',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildStatItem(
//                           'Hadir',
//                           _stats?.present ?? 0,
//                           Colors.green,
//                         ),
//                         _buildStatItem(
//                           'Terlambat',
//                           _stats?.late ?? 0,
//                           Colors.orange,
//                         ),
//                         _buildStatItem(
//                           'Absen',
//                           _stats?.absent ?? 0,
//                           Colors.red,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _showPermissionDialog,
//               icon: Icon(Icons.event_busy),
//               label: Text('Ajukan Izin'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String title, int value, Color color) {
//     return Column(
//       children: [
//         Text(
//           '$value',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(title),
//       ],
//     );
//   }
// }
