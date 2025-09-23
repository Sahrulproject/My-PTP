// import 'package:flutter/material.dart' hide DateUtils;
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:myptp/models/riwayat_kehadiran_model.dart';
// import 'package:myptp/preference/shared_preference.dart';
// import 'package:myptp/utils/date_utils.dart'; // Import DateUtils
// import 'package:myptp/views/auth/login_screen.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//   static String id = "/dashboard";

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   DateTime? _selectedDate;
//   List<AttendanceRecord> _attendanceHistory = [];
//   int _currentIndex = 0;
//   bool _isEditing = false;
//   bool _isCheckingIn = false;
//   bool _isCheckingOut = false;
//   List<AttendanceRecord> _todayRecords = [];

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _positionController = TextEditingController();

//   // Data dummy untuk history kehadiran
//   final List<AttendanceRecord> _allRecords = [
//     AttendanceRecord(
//       DateTime(2023, 10, 1),
//       'Hadir',
//       '08:00',
//       '17:00',
//       'Kantor Pusat',
//     ),
//     AttendanceRecord(
//       DateTime(2023, 10, 2),
//       'Hadir',
//       '08:15',
//       '16:45',
//       'Kantor Pusat',
//     ),
//     AttendanceRecord(DateTime(2023, 10, 3), 'Izin', '', '', 'Izin sakit'),
//     AttendanceRecord(
//       DateTime(2023, 10, 4),
//       'Hadir',
//       '07:55',
//       '17:10',
//       'Kantor Pusat',
//     ),
//     AttendanceRecord(DateTime(2023, 10, 5), 'Alfa', '', '', ''),
//   ];

//   // Data profil pengguna
//   final Map<String, String> _userProfile = {
//     'name': 'Muhammad Sahrul Hakim',
//     'email': 'sahrul@gmail.com',
//     'phone': '+62 812 3456 7890',
//     'position': 'Software Developer',
//     'location': 'Jakarta, Indonesia',
//   };

//   GoogleMapController? mapController;
//   LatLng _currentPosition = const LatLng(
//     -6.200000,
//     106.816666,
//   ); // Default to Jakarta
//   double lat = -6.200000;
//   double long = 106.816666;
//   String _currentAddress = "Alamat tidak ditemukan";
//   Marker? _marker;

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         return;
//       }
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       lat = position.latitude;
//       long = position.longitude;
//     });

//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentPosition.latitude,
//         _currentPosition.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         setState(() {
//           _marker = Marker(
//             markerId: const MarkerId("lokasi_saya"),
//             position: _currentPosition,
//             infoWindow: InfoWindow(
//               title: 'Lokasi Anda',
//               snippet: "${place.street}, ${place.locality}",
//             ),
//           );

//           _currentAddress =
//               "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
//         });

//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: _currentPosition, zoom: 16),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Error getting address: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _attendanceHistory = _allRecords;
//     _nameController.text = _userProfile['name']!;
//     _emailController.text = _userProfile['email']!;
//     _phoneController.text = _userProfile['phone']!;
//     _positionController.text = _userProfile['position']!;

//     // Cek status kehadiran hari ini
//     _checkTodayAttendance();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _positionController.dispose();
//     super.dispose();
//   }

//   // === Fungsi untuk check-in/check-out ===
//   void _checkTodayAttendance() {
//     final today = DateTime.now();
//     setState(() {
//       _todayRecords = _allRecords.where((record) {
//         return record.date.year == today.year &&
//             record.date.month == today.month &&
//             record.date.day == today.day;
//       }).toList();
//     });
//   }

//   Future<void> _checkIn() async {
//     setState(() {
//       _isCheckingIn = true;
//     });

//     // Simulasi proses check-in
//     await Future.delayed(const Duration(seconds: 2));

//     final now = DateTime.now();
//     final formattedTime = DateUtils.formatTime(now);

//     // Tambahkan record baru
//     final newRecord = AttendanceRecord(
//       now,
//       'Hadir',
//       formattedTime,
//       '',
//       'Check-in pada $formattedTime',
//     );

//     setState(() {
//       _allRecords.add(newRecord);
//       _todayRecords.add(newRecord);
//       _isCheckingIn = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Check-in berhasil pada $formattedTime')),
//     );
//   }

//   Future<void> _checkOut() async {
//     // Cari record check-in hari ini
//     final todayRecord = _todayRecords.firstWhere(
//       (record) => record.clockIn.isNotEmpty && record.clockOut.isEmpty,
//       orElse: () => AttendanceRecord(DateTime.now(), '', '', '', ''),
//     );

//     if (todayRecord.clockIn.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Anda belum check-in hari ini')),
//       );
//       return;
//     }

//     setState(() {
//       _isCheckingOut = true;
//     });

//     // Simulasi proses check-out
//     await Future.delayed(const Duration(seconds: 2));

//     final now = DateTime.now();
//     final formattedTime = DateUtils.formatTime(now);

//     // Update record dengan check-out
//     setState(() {
//       todayRecord.clockOut = formattedTime;
//       todayRecord.note = '${todayRecord.note}\nCheck-out pada $formattedTime';
//       _isCheckingOut = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Check-out berhasil pada $formattedTime')),
//     );
//   }

//   // === Fungsi Logout ===
//   Future<void> _logout() async {
//     await PreferenceHandler.removeToken();
//     await PreferenceHandler.removeLogin();

//     Navigator.pushReplacementNamed(context, LoginScreen.id);
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Konfirmasi Logout"),
//           content: const Text("Apakah Anda yakin ingin keluar?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Batal"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await _logout();
//               },
//               child: const Text("Logout", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // === Filter & History ===
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       helpText: 'Pilih Tanggal',
//       cancelText: 'Batal',
//       confirmText: 'Pilih',
//     );

//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _filterAttendanceHistory(picked);
//       });
//     }
//   }

//   void _filterAttendanceHistory(DateTime date) {
//     setState(() {
//       _attendanceHistory = _allRecords.where((record) {
//         return record.date.year == date.year && record.date.month == date.month;
//       }).toList();
//     });
//   }

//   // === Edit Profile ===
//   void _saveProfile() {
//     setState(() {
//       _userProfile['name'] = _nameController.text;
//       _userProfile['email'] = _emailController.text;
//       _userProfile['phone'] = _phoneController.text;
//       _userProfile['position'] = _positionController.text;
//       _isEditing = false;
//     });

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Profil berhasil disimpan')));
//   }

//   void _cancelEdit() {
//     setState(() {
//       _nameController.text = _userProfile['name']!;
//       _emailController.text = _userProfile['email']!;
//       _phoneController.text = _userProfile['phone']!;
//       _positionController.text = _userProfile['position']!;
//       _isEditing = false;
//     });
//   }

//   // === Utils untuk status ===
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Hadir':
//         return Colors.green;
//       case 'Izin':
//         return Colors.orange;
//       case 'Alfa':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'Hadir':
//         return Icons.check_circle;
//       case 'Izin':
//         return Icons.info;
//       case 'Alfa':
//         return Icons.cancel;
//       default:
//         return Icons.help;
//     }
//   }

//   // === Build UI ===
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: _currentIndex == 1 && _isEditing
//             ? const Text("Edit Profil")
//             : const Text("Dashboard Kehadiran"),
//         backgroundColor: Colors.blue,
//         actions: _currentIndex == 0
//             ? [
//                 IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: () => _pickDate(context),
//                 ),
//               ]
//             : _currentIndex == 1 && _isEditing
//             ? [
//                 IconButton(
//                   icon: const Icon(Icons.save),
//                   onPressed: _saveProfile,
//                   tooltip: 'Simpan Perubahan',
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.cancel),
//                   onPressed: _cancelEdit,
//                   tooltip: 'Batal Edit',
//                 ),
//               ]
//             : _currentIndex == 1
//             ? [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     setState(() {
//                       _isEditing = true;
//                     });
//                   },
//                   tooltip: 'Edit Profil',
//                 ),
//               ]
//             : [],
//       ),
//       body: _getCurrentPage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             if (_isEditing && index != 1) {
//               _isEditing = false;
//             }
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Pengaturan',
//           ),
//         ],
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//       ),
//     );
//   }

//   Widget _getCurrentPage() {
//     switch (_currentIndex) {
//       case 0:
//         return _buildAttendancePage();
//       case 1:
//         return _buildProfilePage();
//       case 2:
//         return _buildHistoryPage();
//       case 3:
//         return _buildSettingsPage();
//       default:
//         return _buildAttendancePage();
//     }
//   }

//   // === Page: Kehadiran ===
//   Widget _buildAttendancePage() {
//     final hasCheckedIn = _todayRecords.any(
//       (record) => record.clockIn.isNotEmpty,
//     );
//     final hasCheckedOut = _todayRecords.any(
//       (record) => record.clockOut.isNotEmpty,
//     );

//     return Column(
//       children: [
//         // Header dengan tanggal
//         Container(
//           padding: const EdgeInsets.all(16),
//           color: Colors.blue.shade50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 DateUtils.formatReadableDate(DateTime.now()),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 DateUtils.formatTime(DateTime.now()),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Google Maps
//         SizedBox(
//           height: 300,
//           child: GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _currentPosition,
//               zoom: 16,
//             ),
//             markers: _marker != null ? {_marker!} : {},
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             mapType: MapType.normal,
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//             },
//           ),
//         ),

//         // Location info
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Koordinat: ${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}',
//                 style: const TextStyle(fontSize: 12),
//               ),
//               Text(
//                 'Alamat: $_currentAddress',
//                 style: const TextStyle(fontSize: 12),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),

//         // Refresh location button
//         ElevatedButton(
//           onPressed: _getCurrentLocation,
//           child: const Text("Refresh Lokasi"),
//         ),

//         // Tombol Check-in/Check-out
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: hasCheckedIn || _isCheckingIn ? null : _checkIn,
//                   icon: const Icon(Icons.login),
//                   label: _isCheckingIn
//                       ? const CircularProgressIndicator()
//                       : Text(hasCheckedIn ? 'Sudah Check-in' : 'Check-in'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: (hasCheckedIn && !hasCheckedOut && !_isCheckingOut)
//                       ? _checkOut
//                       : null,
//                   icon: const Icon(Icons.logout),
//                   label: _isCheckingOut
//                       ? const CircularProgressIndicator()
//                       : Text(hasCheckedOut ? 'Sudah Check-out' : 'Check-out'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Status hari ini
//         if (_todayRecords.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.today, color: Colors.blue),
//                 title: const Text('Kehadiran Hari Ini'),
//                 subtitle: Text(
//                   _todayRecords.first.clockIn.isNotEmpty
//                       ? 'Check-in: ${_todayRecords.first.clockIn}'
//                       : 'Belum check-in',
//                 ),
//                 trailing: _todayRecords.first.clockOut.isNotEmpty
//                     ? Text('Check-out: ${_todayRecords.first.clockOut}')
//                     : null,
//               ),
//             ),
//           ),

//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   // === Page: Profil ===
//   Widget _buildProfilePage() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Center(
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.blue.shade100,
//                   child: const Icon(Icons.person, size: 40, color: Colors.blue),
//                 ),
//                 const SizedBox(height: 16),
//                 _isEditing
//                     ? TextFormField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Nama',
//                           border: OutlineInputBorder(),
//                         ),
//                       )
//                     : Text(
//                         _userProfile['name']!,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                 const SizedBox(height: 8),
//                 _isEditing
//                     ? TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                       )
//                     : Text(
//                         _userProfile['email']!,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           _isEditing
//               ? Column(
//                   children: [
//                     TextFormField(
//                       controller: _positionController,
//                       decoration: const InputDecoration(
//                         labelText: 'Posisi',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: const InputDecoration(
//                         labelText: 'Telepon',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.phone,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue: _userProfile['location'],
//                       decoration: const InputDecoration(
//                         labelText: 'Lokasi',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         _userProfile['location'] = value;
//                       },
//                     ),
//                   ],
//                 )
//               : Column(
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.work),
//                       title: const Text('Posisi'),
//                       subtitle: Text(_userProfile['position']!),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.phone),
//                       title: const Text('Telepon'),
//                       subtitle: Text(_userProfile['phone']!),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.location_on),
//                       title: const Text('Lokasi'),
//                       subtitle: Text(_userProfile['location']!),
//                     ),
//                   ],
//                 ),
//         ],
//       ),
//     );
//   }

//   // === Page: Riwayat ===
//   Widget _buildHistoryPage() {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           color: Colors.blue.shade50,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 _selectedDate == null
//                     ? "Menampilkan semua history kehadiran"
//                     : "History kehadiran: ${_selectedDate!.month}-${_selectedDate!.year}",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _attendanceHistory.length,
//             itemBuilder: (context, index) {
//               final record = _attendanceHistory[index];
//               return _buildAttendanceCard(record);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // === Page: Pengaturan ===
//   Widget _buildSettingsPage() {
//     bool notificationsEnabled = true;
//     bool darkMode = false;

//     return StatefulBuilder(
//       builder: (context, setState) {
//         return ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             const Text(
//               'Pengaturan',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SwitchListTile(
//               title: const Text('Notifikasi'),
//               subtitle: const Text('Aktifkan notifikasi aplikasi'),
//               value: notificationsEnabled,
//               onChanged: (value) {
//                 setState(() {
//                   notificationsEnabled = value;
//                 });
//               },
//             ),
//             SwitchListTile(
//               title: const Text('Mode Gelap'),
//               subtitle: const Text('Tampilkan aplikasi dalam mode gelap'),
//               value: darkMode,
//               onChanged: (value) {
//                 setState(() {
//                   darkMode = value;
//                 });
//               },
//             ),
//             const ListTile(
//               leading: Icon(Icons.language),
//               title: Text('Bahasa'),
//               subtitle: Text('Indonesia'),
//               trailing: Icon(Icons.arrow_forward_ios),
//             ),
//             const ListTile(
//               leading: Icon(Icons.help),
//               title: Text('Bantuan'),
//               subtitle: Text('Pusat bantuan dan dukungan'),
//               trailing: Icon(Icons.arrow_forward_ios),
//             ),
//             const ListTile(
//               leading: Icon(Icons.info),
//               title: Text('Tentang'),
//               subtitle: Text('Informasi tentang aplikasi'),
//               trailing: Icon(Icons.arrow_forward_ios),
//             ),
//             const SizedBox(height: 24),
//             ListTile(
//               leading: const Icon(Icons.logout_outlined, color: Colors.red),
//               title: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: _showLogoutDialog,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAttendanceCard(AttendanceRecord record) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         leading: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: _getStatusColor(record.status).withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             _getStatusIcon(record.status),
//             color: _getStatusColor(record.status),
//           ),
//         ),
//         title: Text(
//           "${record.date.day}-${record.date.month}-${record.date.year}",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: record.status == 'Hadir'
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Masuk: ${record.clockIn} | Keluar: ${record.clockOut}"),
//                   if (record.note != null && record.note!.isNotEmpty)
//                     Text(
//                       record.note!,
//                       style: const TextStyle(fontSize: 12),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                 ],
//               )
//             : Text(record.note ?? record.status),
//         trailing: Chip(
//           label: Text(
//             record.status,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: _getStatusColor(record.status),
//         ),
//       ),
//     );
//   }
// }

// ayam
// import 'dart:convert';

// import 'package:flutter/material.dart' hide DateUtils;
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:myptp/utils/date_utils.dart'; // Import DateUtils
// import 'package:myptp/views/history_screen.dart';
// import 'package:myptp/views/izin_page.dart';
// import 'package:myptp/views/profile_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   static const id = '/home';

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final List<Widget> _pages = [
//     const HomePage(),
//     const IzinPage(),
//     const AttendancePage(),
//     const ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _selectedIndex == 0
//               ? 'Dashboard'
//               : _selectedIndex == 1
//               ? 'Izin'
//               : _selectedIndex == 2
//               ? 'Attendance'
//               : 'Profile',
//         ),
//         backgroundColor: const Color(0xFF2D3748),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_outlined),
//             activeIcon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.email_outlined),
//             activeIcon: Icon(Icons.email),
//             label: 'Izin',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.access_time_outlined),
//             activeIcon: Icon(Icons.access_time),
//             label: 'Attendance',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outlined),
//             activeIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color(0xFF2D3748),
//         unselectedItemColor: Colors.grey[400],
//         type: BottomNavigationBarType.fixed,
//         onTap: _onItemTapped,
//       ),
//       drawer: _buildDrawer(),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF2D3748), Color(0xFF764ba2)],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 40, color: Color(0xFF667eea)),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Muhammad Sahrul Hakim',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Employee ID: EMP001',
//                   style: TextStyle(color: Colors.white.withOpacity(0.9)),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () {
//               _onItemTapped(0);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.access_time),
//             title: const Text('Attendance History'),
//             onTap: () {
//               _onItemTapped(2);
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Profile'),
//             onTap: () {
//               _onItemTapped(3);
//               Navigator.pop(context);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.help_outline),
//             title: const Text('Help & Support'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Home Page Content - Dashboard Absensi
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Position? _currentPosition;
//   bool _isLoadingLocation = false;
//   bool _isCheckingIn = false;
//   bool _isCheckingOut = false;

//   Map<String, dynamic>? _todayAttendance;
//   Map<String, dynamic>? _attendanceStats;
//   bool _isLoadingData = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   Future<void> _loadDashboardData() async {
//     await Future.wait([_getTodayAttendance(), _getAttendanceStats()]);
//     setState(() {
//       _isLoadingData = false;
//     });
//   }

//   Future<Position?> _getCurrentLocation() async {
//     setState(() {
//       _isLoadingLocation = true;
//     });

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         _showSnackBar('Location services are disabled. Please enable them.');
//         return null;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           _showSnackBar('Location permissions are denied');
//           return null;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         _showSnackBar('Location permissions are permanently denied');
//         return null;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentPosition = position;
//       });

//       return position;
//     } catch (e) {
//       _showSnackBar('Error getting location: $e');
//       return null;
//     } finally {
//       setState(() {
//         _isLoadingLocation = false;
//       });
//     }
//   }

//   Future<void> _checkIn() async {
//     setState(() {
//       _isCheckingIn = true;
//     });

//     Position? position = await _getCurrentLocation();
//     if (position == null) {
//       setState(() {
//         _isCheckingIn = false;
//       });
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('https://appabsensi.mobileprojp.com/api/absen/check-in'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'Bearer YOUR_TOKEN_HERE', // Replace with actual token
//         },
//         body: json.encode({
//           'attendance_date': DateUtils.formatDate(DateTime.now()),
//           'check_in_time': DateUtils.formatTime(DateTime.now()),
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'location_accuracy': position.accuracy,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _showSnackBar('Check-in successful!', isSuccess: true);
//         await _getTodayAttendance(); // Refresh today's data
//         await _getAttendanceStats(); // Refresh stats
//       } else {
//         _showSnackBar('Check-in failed. Please try again.');
//       }
//     } catch (e) {
//       _showSnackBar('Error during check-in: $e');
//     } finally {
//       setState(() {
//         _isCheckingIn = false;
//       });
//     }
//   }

//   Future<void> _checkOut() async {
//     setState(() {
//       _isCheckingOut = true;
//     });

//     Position? position = await _getCurrentLocation();
//     if (position == null) {
//       setState(() {
//         _isCheckingOut = false;
//       });
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('https://appabsensi.mobileprojp.com/api/absen/check-out'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'Bearer YOUR_TOKEN_HERE', // Replace with actual token
//         },
//         body: json.encode({
//           'attendance_date': DateUtils.formatDate(DateTime.now()),
//           'check_out_time': DateUtils.formatTime(DateTime.now()),
//           'latitude': position.latitude,
//           'longitude': position.longitude,
//           'location_accuracy': position.accuracy,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         _showSnackBar('Check-out successful!', isSuccess: true);
//         await _getTodayAttendance(); // Refresh today's data
//         await _getAttendanceStats(); // Refresh stats
//       } else {
//         _showSnackBar('Check-out failed. Please try again.');
//       }
//     } catch (e) {
//       _showSnackBar('Error during check-out: $e');
//     } finally {
//       setState(() {
//         _isCheckingOut = false;
//       });
//     }
//   }

//   Future<void> _getTodayAttendance() async {
//     try {
//       final today = DateUtils.formatDate(DateTime.now());
//       final response = await http.get(
//         Uri.parse(
//           'https://appabsensi.mobileprojp.com/api/absen/today?attendance_date=$today',
//         ),
//         headers: {
//           'Authorization':
//               'Bearer YOUR_TOKEN_HERE', // Replace with actual token
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _todayAttendance = json.decode(response.body);
//         });
//       }
//     } catch (e) {
//       print('Error fetching today attendance: $e');
//     }
//   }

//   Future<void> _getAttendanceStats() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://appabsensi.mobileprojp.com/api/absen/stats'),
//         headers: {
//           'Authorization':
//               'Bearer YOUR_TOKEN_HERE', // Replace with actual token
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _attendanceStats = json.decode(response.body);
//         });
//       }
//     } catch (e) {
//       print('Error fetching attendance stats: $e');
//     }
//   }

//   void _showSnackBar(String message, {bool isSuccess = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final today = DateTime.now();
//     final formattedDate = DateUtils.formatReadableDate(today);

//     return RefreshIndicator(
//       onRefresh: _loadDashboardData,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             _buildHeaderSection(formattedDate),
//             const SizedBox(height: 24),

//             // Today's Status Card
//             _buildTodayStatusCard(),
//             const SizedBox(height: 20),

//             // Check-in/Check-out Buttons
//             _buildAttendanceButtons(),
//             const SizedBox(height: 24),

//             // Statistics Section
//             _buildStatisticsSection(),
//             const SizedBox(height: 20),

//             // Location Info
//             _buildLocationInfo(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection(String formattedDate) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF2D3748), Color(0xFF764ba2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 child: Icon(Icons.person, color: Colors.white, size: 30),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Muhammad Sahrul Hakim',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Trainings: Mobile Programming B3',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             formattedDate,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTodayStatusCard() {
//     if (_isLoadingData) {
//       return _buildLoadingCard();
//     }

//     final checkIn = _todayAttendance?['check_in_time'];
//     final checkOut = _todayAttendance?['check_out_time'];
//     final status = _todayAttendance?['status'] ?? 'Not Checked In';

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.today, color: Color(0xFF2D3748), size: 24),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Today\'s Attendance',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTimeCard(
//                     'Check In',
//                     checkIn ?? '--:--',
//                     Icons.login,
//                     Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildTimeCard(
//                     'Check Out',
//                     checkOut ?? '--:--',
//                     Icons.logout,
//                     Colors.orange,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: _getStatusColor(status).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 'Status: $status',
//                 style: TextStyle(
//                   color: _getStatusColor(status),
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeCard(String title, String time, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 20),
//           const SizedBox(height: 4),
//           Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//           const SizedBox(height: 4),
//           Text(
//             time,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttendanceButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: _isCheckingIn ? null : _checkIn,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: _isCheckingIn
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(Icons.login),
//             label: Text(
//               _isCheckingIn ? 'Processing...' : 'Check In',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: _isCheckingOut ? null : _checkOut,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: _isCheckingOut
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(Icons.logout),
//             label: Text(
//               _isCheckingOut ? 'Processing...' : 'Check Out',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatisticsSection() {
//     if (_isLoadingData) {
//       return _buildLoadingCard();
//     }

//     final totalPresent = _attendanceStats?['total_present'] ?? 0;
//     final totalLate = _attendanceStats?['total_late'] ?? 0;
//     final totalAbsent = _attendanceStats?['total_absent'] ?? 0;
//     final attendanceRate = _attendanceStats?['attendance_rate'] ?? 0.0;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.bar_chart, color: Color(0xFF2D3748), size: 24),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Attendance Statistics',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildStatCard(
//                     'Present',
//                     totalPresent.toString(),
//                     Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Late',
//                     totalLate.toString(),
//                     Colors.orange,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Absent',
//                     totalAbsent.toString(),
//                     Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF2D3748).withOpacity(0.1),
//                     Color(0xFF2D3750).withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Attendance Rate',
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${(attendanceRate * 100).toStringAsFixed(1)}%',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationInfo() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.location_on, color: Color(0xFF2D3748), size: 24),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Location Info',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             if (_currentPosition != null) ...[
//               Text(
//                 'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)}m',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//             ] else ...[
//               Text(
//                 'Location not detected',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 8),
//               TextButton.icon(
//                 onPressed: _getCurrentLocation,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Refresh Location'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: const Padding(
//         padding: EdgeInsets.all(40),
//         child: Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'present':
//         return Colors.green;
//       case 'late':
//         return Colors.orange;
//       case 'absent':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }
