// views/auth/dashboard.dart
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myptp/extension/navigation.dart';
import 'package:myptp/models/riwayat_kehadiran_model.dart'; // Import class yang dipisahkan
import 'package:myptp/preference/shared_preference.dart';
import 'package:myptp/views/auth/login_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static String id = "dashboard";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? _selectedDate;
  List<AttendanceRecord> _attendanceHistory = [];
  int _currentIndex = 0;
  bool _isEditing = false;
  bool _isCheckingIn = false;
  bool _isCheckingOut = false;
  List<AttendanceRecord> _todayRecords = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  // Data dummy untuk history kehadiran
  final List<AttendanceRecord> _allRecords = [
    AttendanceRecord(
      DateTime(2023, 10, 1),
      'Hadir',
      '08:00',
      '17:00',
      'Kantor Pusat',
    ),
    AttendanceRecord(
      DateTime(2023, 10, 2),
      'Hadir',
      '08:15',
      '16:45',
      'Kantor Pusat',
    ),
    AttendanceRecord(DateTime(2023, 10, 3), 'Izin', '', '', 'Izin sakit'),
    AttendanceRecord(
      DateTime(2023, 10, 4),
      'Hadir',
      '07:55',
      '17:10',
      'Kantor Pusat',
    ),
    AttendanceRecord(DateTime(2023, 10, 5), 'Alfa', '', '', ''),
  ];

  // Data profil pengguna
  final Map<String, String> _userProfile = {
    'name': 'Muhammad Sahrul Hakim',
    'email': 'sahrul@gmail.com',
    'phone': '+62 812 3456 7890',
    'position': 'Software Developer',
    'location': 'Jakarta, Indonesia',
  };

  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666); // Default to Jakarta
  double lat = -6.200000;
  double long = 106.816666;
  String _currentAddress = "Alamat tidak ditemukan";
  Marker? _marker;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);
    lat = position.latitude;
    long = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );

      _currentAddress =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      print(_currentAddress);
      print(_currentPosition);
      print("${place.street}, ${place.locality}");
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _attendanceHistory = _allRecords;
    _nameController.text = _userProfile['name']!;
    _emailController.text = _userProfile['email']!;
    _phoneController.text = _userProfile['phone']!;
    _positionController.text = _userProfile['position']!;

    // Cek status kehadiran hari ini
    _checkTodayAttendance();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  // === Fungsi untuk check-in/check-out ===
  void _checkTodayAttendance() {
    final today = DateTime.now();
    setState(() {
      _todayRecords = _allRecords.where((record) {
        return record.date.year == today.year &&
            record.date.month == today.month &&
            record.date.day == today.day;
      }).toList();
    });
  }

  Future<void> _checkIn() async {
    setState(() {
      _isCheckingIn = true;
    });

    // Simulasi proses check-in
    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);

    // Tambahkan record baru
    final newRecord = AttendanceRecord(
      now,
      'Hadir',
      formattedTime,
      '',
      'Check-in pada $formattedTime',
    );

    setState(() {
      _allRecords.add(newRecord);
      _todayRecords.add(newRecord);
      _isCheckingIn = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Check-in berhasil pada $formattedTime')),
    );
  }

  Future<void> _checkOut() async {
    // Cari record check-in hari ini
    final todayRecord = _todayRecords.firstWhere(
      (record) => record.clockIn.isNotEmpty && record.clockOut.isEmpty,
      orElse: () => AttendanceRecord(DateTime.now(), '', '', '', ''),
    );

    if (todayRecord.clockIn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum check-in hari ini')),
      );
      return;
    }

    setState(() {
      _isCheckingOut = true;
    });

    // Simulasi proses check-out
    await Future.delayed(const Duration(seconds: 2));

    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);

    // Update record dengan check-out
    setState(() {
      todayRecord.clockOut = formattedTime;
      todayRecord.note = '${todayRecord.note}\nCheck-out pada $formattedTime';
      _isCheckingOut = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Check-out berhasil pada $formattedTime')),
    );
  }

  // === Fungsi Logout ===
  Future<void> _logout() async {
    await PreferenceHandler.removeToken();
    await PreferenceHandler.removeLogin();

    Navigator.pushReplacementNamed(context, '/login_screen');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Berhasil logout')));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                context.pushNamedAndRemoveUntil(
                  LoginScreen.id,
                  (route) => false,
                );
                await _logout();
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // === Filter & History ===
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterAttendanceHistory(picked);
      });
    }
  }

  void _filterAttendanceHistory(DateTime date) {
    setState(() {
      _attendanceHistory = _allRecords.where((record) {
        return record.date.year == date.year && record.date.month == date.month;
      }).toList();
    });
  }

  // === Edit Profile ===
  void _saveProfile() {
    setState(() {
      _userProfile['name'] = _nameController.text;
      _userProfile['email'] = _emailController.text;
      _userProfile['phone'] = _phoneController.text;
      _userProfile['position'] = _positionController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil berhasil disimpan')));
  }

  void _cancelEdit() {
    setState(() {
      _nameController.text = _userProfile['name']!;
      _emailController.text = _userProfile['email']!;
      _phoneController.text = _userProfile['phone']!;
      _positionController.text = _userProfile['position']!;
      _isEditing = false;
    });
  }

  // === Utils untuk status ===
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Izin':
        return Colors.orange;
      case 'Alfa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Hadir':
        return Icons.check_circle;
      case 'Izin':
        return Icons.info;
      case 'Alfa':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  // === Build UI ===
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 1 && _isEditing
            ? const Text("Edit Profil")
            : const Text("Dashboard Kehadiran"),
        backgroundColor: Colors.blue,
        actions: _currentIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context),
                ),
              ]
            : _currentIndex == 1 && _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveProfile,
                  tooltip: 'Simpan Perubahan',
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: _cancelEdit,
                  tooltip: 'Batal Edit',
                ),
              ]
            : _currentIndex == 1
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  tooltip: 'Edit Profil',
                ),
              ]
            : [],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_isEditing && index != 1) {
              _isEditing = false;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _getCurrentPage() {
    final theme = Theme.of(context);

    switch (_currentIndex) {
      case 0:
        return _buildAttendancePage();
      case 1:
        return _buildProfilePage();
      case 2:
        return _buildHistoryPage();
      case 3:
        return _buildSettingsPage(theme);
      default:
        return _buildAttendancePage();
    }
  }

  // === Page: Kehadiran ===
  Widget _buildAttendancePage() {
    final hasCheckedIn = _todayRecords.any(
      (record) => record.clockIn.isNotEmpty,
    );
    final hasCheckedOut = _todayRecords.any(
      (record) => record.clockOut.isNotEmpty,
    );

    return Column(
      children: [
        // Header dengan tanggal
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, d MMMM y').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
        ),
        Text(_currentPosition.toString()),
        Text(_currentAddress.toString()),
        ElevatedButton(
          onPressed: () {
            _getCurrentLocation();
          },
          child: Text("Get Current Location"),
        ),

        // Tombol Check-in/Check-out
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasCheckedIn || _isCheckingIn ? null : _checkIn,
                  icon: const Icon(Icons.login),
                  label: _isCheckingIn
                      ? const CircularProgressIndicator()
                      : Text(hasCheckedIn ? 'Sudah Check-in' : 'Check-in'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (hasCheckedIn && !hasCheckedOut && !_isCheckingOut)
                      ? _checkOut
                      : null,
                  icon: const Icon(Icons.logout),
                  label: _isCheckingOut
                      ? const CircularProgressIndicator()
                      : Text(hasCheckedOut ? 'Sudah Check-out' : 'Check-out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Status hari ini
        if (_todayRecords.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.today, color: Colors.blue),
                title: const Text('Kehadiran Hari Ini'),
                subtitle: Text(
                  _todayRecords.first.clockIn.isNotEmpty
                      ? 'Check-in: ${_todayRecords.first.clockIn}'
                      : 'Belum check-in',
                ),
                trailing: _todayRecords.first.clockOut.isNotEmpty
                    ? Text('Check-out: ${_todayRecords.first.clockOut}')
                    : null,
              ),
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }

  // === Page: Profil ===
  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                _isEditing
                    ? TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text(
                        _userProfile['name']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 8),
                _isEditing
                    ? TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )
                    : Text(
                        _userProfile['email']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _isEditing
              ? Column(
                  children: [
                    TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(
                        labelText: 'Posisi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telepon',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _userProfile['location'],
                      decoration: const InputDecoration(
                        labelText: 'Lokasi',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _userProfile['location'] = value;
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.work),
                      title: const Text('Posisi'),
                      subtitle: Text(_userProfile['position']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Telepon'),
                      subtitle: Text(_userProfile['phone']!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Lokasi'),
                      subtitle: Text(_userProfile['location']!),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // === Page: Riwayat ===
  Widget _buildHistoryPage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedDate == null
                    ? "Menampilkan semua history kehadiran"
                    : "History kehadiran: ${_selectedDate!.month}-${_selectedDate!.year}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _attendanceHistory.length,
            itemBuilder: (context, index) {
              final record = _attendanceHistory[index];
              return _buildAttendanceCard(record);
            },
          ),
        ),
      ],
    );
  }

  // === Page: Pengaturan ===
  Widget _buildSettingsPage(ThemeData theme) {
    bool notificationsEnabled = true;
    bool darkMode = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Pengaturan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Notifikasi'),
              subtitle: const Text('Aktifkan notifikasi aplikasi'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Tampilkan aplikasi dalam mode gelap'),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Bahasa'),
              subtitle: Text('Indonesia'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.help),
              title: Text('Bantuan'),
              subtitle: Text('Pusat bantuan dan dukungan'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('Tentang'),
              subtitle: Text('Informasi tentang aplikasi'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              onTap: _showLogoutDialog,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticCard(String title, Color color, int count) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(record.status).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(record.status),
            color: _getStatusColor(record.status),
          ),
        ),
        title: Text(
          "${record.date.day}-${record.date.month}-${record.date.year}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: record.status == 'Hadir'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Masuk: ${record.clockIn} | Keluar: ${record.clockOut}"),
                  if (record.note != null && record.note!.isNotEmpty)
                    Text(
                      record.note!,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              )
            : Text(record.note ?? record.status),
        trailing: Chip(
          label: Text(
            record.status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: _getStatusColor(record.status),
        ),
      ),
    );
  }
}
