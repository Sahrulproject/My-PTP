import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Absensi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/history': (context) => HistoryPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

// Model Data
class User {
  final String name;
  final String email;
  final String training;
  final String batch;

  User({
    required this.name,
    required this.email,
    required this.training,
    required this.batch,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      training: json['training'],
      batch: json['batch'],
    );
  }
}

class Attendance {
  final String date;
  final String checkIn;
  final String checkOut;
  final String location;

  Attendance({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.location,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'],
      checkIn: json['check_in'] ?? '-',
      checkOut: json['check_out'] ?? '-',
      location: json['location'] ?? 'Tidak tercatat',
    );
  }
}

class AttendanceStats {
  final int present;
  final int late;
  final int absent;

  AttendanceStats({
    required this.present,
    required this.late,
    required this.absent,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      present: json['present'] ?? 0,
      late: json['late'] ?? 0,
      absent: json['absent'] ?? 0,
    );
  }
}

// Halaman Register
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _trainingController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email harus diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _trainingController,
                decoration: InputDecoration(labelText: 'Training'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Training harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _batchController,
                decoration: InputDecoration(labelText: 'Batch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Batch harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password harus diisi';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Simulasi register
                          await Future.delayed(Duration(seconds: 2));

                          // Simpan data dummy untuk demo
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            'user_data',
                            json.encode({
                              'name': _nameController.text,
                              'email': _emailController.text,
                              'training': _trainingController.text,
                              'batch': _batchController.text,
                            }),
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Registrasi berhasil! Silakan login.',
                              ),
                            ),
                          );

                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: Text('Daftar'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isResetPassword = false;
  final TextEditingController _resetEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isResetPassword ? _buildResetPasswordForm() : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email harus diisi';
              }
              if (!value.contains('@')) {
                return 'Email tidak valid';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password harus diisi';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      // Simulasi login
                      await Future.delayed(Duration(seconds: 2));

                      // Simpan token dummy
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('auth_token', 'dummy_token_12345');

                      setState(() {
                        _isLoading = false;
                      });

                      Navigator.pushReplacementNamed(context, '/dashboard');
                    }
                  },
                  child: Text('Login'),
                ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            child: Text('Belum punya akun? Daftar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isResetPassword = true;
              });
            },
            child: Text('Lupa Password?'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return ListView(
      children: [
        Text(
          'Reset Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _resetEmailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            // Simulasi kirim OTP
            await Future.delayed(Duration(seconds: 1));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP telah dikirim ke email Anda')),
            );
          },
          child: Text('Kirim OTP'),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _otpController,
          decoration: InputDecoration(labelText: 'Kode OTP'),
        ),
        TextFormField(
          controller: _newPasswordController,
          decoration: InputDecoration(labelText: 'Password Baru'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Simulasi reset password
                await Future.delayed(Duration(seconds: 2));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password berhasil direset')),
                );
                setState(() {
                  _isResetPassword = false;
                });
              },
              child: Text('Reset Password'),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isResetPassword = false;
                });
              },
              child: Text('Batal'),
            ),
          ],
        ),
      ],
    );
  }
}

// Halaman Dashboard
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? _user;
  Attendance? _todayAttendance;
  AttendanceStats? _stats;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTodayAttendance();
    _loadStats();
  }

  Future<void> _loadUserData() async {
    // Simulasi mengambil data user
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      setState(() {
        _user = User.fromJson(json.decode(userData));
      });
    }
  }

  Future<void> _loadTodayAttendance() async {
    // Simulasi mengambil data absen hari ini
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _todayAttendance = Attendance(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        checkIn: '08:00',
        checkOut: '17:00',
        location: 'Jakarta, Indonesia',
      );
    });
  }

  Future<void> _loadStats() async {
    // Simulasi mengambil statistik
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _stats = AttendanceStats(present: 20, late: 2, absent: 3);
    });
  }

  Future<void> _checkIn() async {
    // Simulasi absen masuk
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Absen masuk berhasil')));
    _loadTodayAttendance();
  }

  Future<void> _checkOut() async {
    // Simulasi absen pulang
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Absen pulang berhasil')));
    _loadTodayAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                  SizedBox(height: 10),
                  Text(
                    _user?.name ?? 'Loading...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    _user?.email ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Riwayat Absensi'),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${_user?.name ?? ''}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _checkIn,
                    icon: Icon(Icons.login),
                    label: Text('Absen Masuk'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _checkOut,
                    icon: Icon(Icons.logout),
                    label: Text('Absen Pulang'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Absensi Hari Ini',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Masuk:'),
                        Text(_todayAttendance?.checkIn ?? 'Belum absen'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Pulang:'),
                        Text(_todayAttendance?.checkOut ?? 'Belum absen'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lokasi:'),
                        Text(_todayAttendance?.location ?? 'Tidak tercatat'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistik Absensi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Hadir',
                          _stats?.present ?? 0,
                          Colors.green,
                        ),
                        _buildStatItem(
                          'Terlambat',
                          _stats?.late ?? 0,
                          Colors.orange,
                        ),
                        _buildStatItem(
                          'Absen',
                          _stats?.absent ?? 0,
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Fitur izin (bonus)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Ajukan Izin'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Tanggal'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Alasan'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Simulasi pengajuan izin
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Izin berhasil diajukan')),
                          );
                        },
                        child: Text('Ajukan'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.event_busy),
              label: Text('Ajukan Izin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title),
      ],
    );
  }
}

// Halaman Riwayat Absensi
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Attendance> _attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    // Simulasi mengambil riwayat absensi
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _attendanceHistory = [
        Attendance(
          date: '2023-10-01',
          checkIn: '08:00',
          checkOut: '17:00',
          location: 'Jakarta',
        ),
        Attendance(
          date: '2023-10-02',
          checkIn: '08:15',
          checkOut: '16:45',
          location: 'Jakarta',
        ),
        Attendance(
          date: '2023-10-03',
          checkIn: '07:45',
          checkOut: '17:30',
          location: 'Jakarta',
        ),
        Attendance(
          date: '2023-10-04',
          checkIn: '08:05',
          checkOut: '17:15',
          location: 'Jakarta',
        ),
        Attendance(
          date: '2023-10-05',
          checkIn: '08:20',
          checkOut: '16:50',
          location: 'Jakarta',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Absensi')),
      body: _attendanceHistory.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _attendanceHistory.length,
              itemBuilder: (context, index) {
                final attendance = _attendanceHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(attendance.date),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Masuk: ${attendance.checkIn}'),
                        Text('Pulang: ${attendance.checkOut}'),
                        Text('Lokasi: ${attendance.location}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Fitur hapus absen (bonus)
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Hapus Absen'),
                            content: Text(
                              'Yakin ingin menghapus data absen ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Simulasi hapus absen
                                  setState(() {
                                    _attendanceHistory.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Absen berhasil dihapus'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Halaman Profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Simulasi mengambil data user
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    if (userData != null) {
      setState(() {
        _user = User.fromJson(json.decode(userData));
        _nameController.text = _user!.name;
      });
    }
  }

  Future<void> _updateProfile() async {
    // Simulasi update profil
    await Future.delayed(Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_data',
      json.encode({
        'name': _nameController.text,
        'email': _user!.email,
        'training': _user!.training,
        'batch': _user!.batch,
      }),
    );

    setState(() {
      _isEditing = false;
      _user = User(
        name: _nameController.text,
        email: _user!.email,
        training: _user!.training,
        batch: _user!.batch,
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profil berhasil diperbarui')));
  }

  Future<void> _updatePhoto() async {
    // Simulasi update foto profil
    await Future.delayed(Duration(seconds: 1));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Foto profil berhasil diperbarui')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Pengguna')),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 15),
                              onPressed: _updatePhoto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _isEditing
                      ? TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Nama'),
                        )
                      : ListTile(
                          title: Text('Nama'),
                          subtitle: Text(_user!.name),
                        ),
                  ListTile(title: Text('Email'), subtitle: Text(_user!.email)),
                  ListTile(
                    title: Text('Training'),
                    subtitle: Text(_user!.training),
                  ),
                  ListTile(title: Text('Batch'), subtitle: Text(_user!.batch)),
                  SizedBox(height: 20),
                  if (_isEditing)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text('Simpan'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _nameController.text = _user!.name;
                            });
                          },
                          child: Text('Batal'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: Text('Edit Profil'),
                    ),
                ],
              ),
            ),
    );
  }
}
