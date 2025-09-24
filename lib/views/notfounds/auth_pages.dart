// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Halaman Register
// class RegisterPage extends StatefulWidget {
//   static const id = "/register";

//   const RegisterPage({super.key});
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _trainingController = TextEditingController();
//   final TextEditingController _batchController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Daftar Akun')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Lengkap',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Nama harus diisi';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email harus diisi';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Email tidak valid';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _trainingController,
//                 decoration: InputDecoration(
//                   labelText: 'Training',
//                   prefixIcon: Icon(Icons.school),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Training harus diisi';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _batchController,
//                 decoration: InputDecoration(
//                   labelText: 'Batch',
//                   prefixIcon: Icon(Icons.group),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Batch harus diisi';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password harus diisi';
//                   }
//                   if (value.length < 6) {
//                     return 'Password minimal 6 karakter';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 24),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isLoading = true;
//                           });

//                           // Simulasi register
//                           await Future.delayed(Duration(seconds: 2));

//                           // Simpan data dummy untuk demo
//                           final prefs = await SharedPreferences.getInstance();
//                           await prefs.setString(
//                             'user_data',
//                             json.encode({
//                               'name': _nameController.text,
//                               'email': _emailController.text,
//                               'training': _trainingController.text,
//                               'batch': _batchController.text,
//                             }),
//                           );

//                           setState(() {
//                             _isLoading = false;
//                           });

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'Registrasi berhasil! Silakan login.',
//                               ),
//                             ),
//                           );

//                           Navigator.pushReplacementNamed(context, '/login');
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Text('Daftar', style: TextStyle(fontSize: 16)),
//                     ),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/login');
//                 },
//                 child: Text('Sudah punya akun? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Halaman Login
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               SizedBox(height: 40),
//               SizedBox(
//                 height: 120,
//                 child: Image.asset('assets/images/newvector_bg.png'),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'SISTEM ABSENSI',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 40),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email harus diisi';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Email tidak valid';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password harus diisi';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 24),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isLoading = true;
//                           });

//                           // Simulasi login
//                           await Future.delayed(Duration(seconds: 2));

//                           // Simpan status login
//                           final prefs = await SharedPreferences.getInstance();
//                           await prefs.setBool('isLoggedIn', true);
//                           await prefs.setString(
//                             'auth_token',
//                             'dummy_token_12345',
//                           );

//                           setState(() {
//                             _isLoading = false;
//                           });

//                           Navigator.pushReplacementNamed(context, '/dashboard');
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: Text('Login', style: TextStyle(fontSize: 16)),
//                     ),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacementNamed(context, '/register');
//                 },
//                 child: Text('Belum punya akun? Daftar'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/forgot-password');
//                 },
//                 child: Text('Lupa Password?'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Halaman Lupa Password
// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();

//   bool _isLoading = false;
//   bool _otpSent = false;
//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Reset Password')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Reset Password',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 prefixIcon: Icon(Icons.email),
//               ),
//               enabled: !_otpSent,
//             ),
//             SizedBox(height: 16),
//             if (_otpSent) ...[
//               TextFormField(
//                 controller: _otpController,
//                 decoration: InputDecoration(
//                   labelText: 'Kode OTP',
//                   prefixIcon: Icon(Icons.lock_clock),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: _newPasswordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password Baru',
//                   prefixIcon: Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//               ),
//               SizedBox(height: 16),
//             ],
//             _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ElevatedButton(
//                     onPressed: () async {
//                       if (!_otpSent) {
//                         // Simulasi kirim OTP
//                         setState(() {
//                           _isLoading = true;
//                         });

//                         await Future.delayed(Duration(seconds: 2));

//                         setState(() {
//                           _isLoading = false;
//                           _otpSent = true;
//                         });

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('OTP telah dikirim ke email Anda'),
//                           ),
//                         );
//                       } else {
//                         // Simulasi reset password
//                         setState(() {
//                           _isLoading = true;
//                         });

//                         await Future.delayed(Duration(seconds: 2));

//                         setState(() {
//                           _isLoading = false;
//                         });

//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Password berhasil direset')),
//                         );

//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(_otpSent ? 'Reset Password' : 'Kirim OTP'),
//                   ),
//             SizedBox(height: 16),
//             if (_otpSent)
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _otpSent = false;
//                   });
//                 },
//                 child: Text('Kembali'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
