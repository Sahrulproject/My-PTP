// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'main.dart';

// // Halaman Riwayat Absensi
// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<Attendance> _attendanceHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAttendanceHistory();
//   }

//   Future<void> _loadAttendanceHistory() async {
//     // Simulasi mengambil riwayat absensi
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {
//       _attendanceHistory = [
//         Attendance(
//           date: '2023-10-01',
//           checkIn: '08:00',
//           checkOut: '17:00',
//           location: 'Jakarta',
//         ),
//         Attendance(
//           date: '2023-10-02',
//           checkIn: '08:15',
//           checkOut: '16:45',
//           location: 'Jakarta',
//         ),
//         Attendance(
//           date: '2023-10-03',
//           checkIn: '07:45',
//           checkOut: '17:30',
//           location: 'Jakarta',
//         ),
//         Attendance(
//           date: '2023-10-04',
//           checkIn: '08:05',
//           checkOut: '17:15',
//           location: 'Jakarta',
//         ),
//         Attendance(
//           date: '2023-10-05',
//           checkIn: '08:20',
//           checkOut: '16:50',
//           location: 'Jakarta',
//         ),
//       ];
//     });
//   }

//   Future<void> _deleteAttendance(int index) async {
//     // Simulasi hapus absen
//     setState(() {
//       _attendanceHistory.removeAt(index);
//     });
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Absen berhasil dihapus')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Riwayat Absensi')),
//       body: _attendanceHistory.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _attendanceHistory.length,
//               itemBuilder: (context, index) {
//                 final attendance = _attendanceHistory[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     title: Text(attendance.date),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Masuk: ${attendance.checkIn}'),
//                         Text('Pulang: ${attendance.checkOut}'),
//                         Text('Lokasi: ${attendance.location}'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text('Hapus Absen'),
//                             content: Text(
//                               'Yakin ingin menghapus data absen ini?',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('Batal'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   _deleteAttendance(index);
//                                   Navigator.pop(context);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                 ),
//                                 child: Text('Hapus'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// // Halaman Profil
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   User? _user;
//   final TextEditingController _nameController = TextEditingController();
//   bool _isEditing = false;
//   bool _isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadThemePreference();
//   }

//   Future<void> _loadUserData() async {
//     // Simulasi mengambil data user
//     final prefs = await SharedPreferences.getInstance();
//     final userData = prefs.getString('user_data');

//     if (userData != null) {
//       setState(() {
//         _user = User.fromJson(json.decode(userData));
//         _nameController.text = _user!.name;
//       });
//     }
//   }

//   Future<void> _loadThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     });
//   }

//   Future<void> _updateProfile() async {
//     // Simulasi update profil
//     await Future.delayed(Duration(seconds: 1));

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(
//       'user_data',
//       json.encode({
//         'name': _nameController.text,
//         'email': _user!.email,
//         'training': _user!.training,
//         'batch': _user!.batch,
//       }),
//     );

//     setState(() {
//       _isEditing = false;
//       _user = User(
//         name: _nameController.text,
//         email: _user!.email,
//         training: _user!.training,
//         batch: _user!.batch,
//       );
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Profil berhasil diperbarui')));
//   }

//   Future<void> _updatePhoto() async {
//     // Simulasi update foto profil
//     await Future.delayed(Duration(seconds: 1));
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Foto profil berhasil diperbarui')));
//   }

//   Future<void> _toggleTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//     await prefs.setBool('isDarkMode', _isDarkMode);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Tema ${_isDarkMode ? 'gelap' : 'terang'} diaktifkan'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profil Pengguna')),
//       body: _user == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           child: Icon(Icons.person, size: 50),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: CircleAvatar(
//                             radius: 15,
//                             child: IconButton(
//                               icon: Icon(Icons.camera_alt, size: 15),
//                               onPressed: _updatePhoto,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   _isEditing
//                       ? TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(labelText: 'Nama'),
//                         )
//                       : ListTile(
//                           title: Text('Nama'),
//                           subtitle: Text(_user!.name),
//                         ),
//                   ListTile(title: Text('Email'), subtitle: Text(_user!.email)),
//                   ListTile(
//                     title: Text('Training'),
//                     subtitle: Text(_user!.training),
//                   ),
//                   ListTile(title: Text('Batch'), subtitle: Text(_user!.batch)),
//                   SwitchListTile(
//                     title: Text('Mode Gelap'),
//                     value: _isDarkMode,
//                     onChanged: (value) {
//                       _toggleTheme();
//                     },
//                   ),
//                   SizedBox(height: 20),
//                   if (_isEditing)
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: _updateProfile,
//                           child: Text('Simpan'),
//                         ),
//                         SizedBox(width: 10),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               _isEditing = false;
//                               _nameController.text = _user!.name;
//                             });
//                           },
//                           child: Text('Batal'),
//                         ),
//                       ],
//                     )
//                   else
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _isEditing = true;
//                         });
//                       },
//                       child: Text('Edit Profil'),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
