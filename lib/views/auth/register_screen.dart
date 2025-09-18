import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myptp/api/register_api.dart';
import 'package:myptp/extension/navigation.dart';
import 'package:myptp/models/list_batches_model.dart';
import 'package:myptp/models/list_training_model.dart';
import 'package:myptp/models/register_model.dart';
import 'package:myptp/preference/shared_preference.dart';
import 'package:myptp/views/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const id = '/post_api_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form key untuk validasi
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Datum? _selectedPelatihan;
  Batches? _selectedBatch;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;
  RegisterUserModel? user;
  String? selectedGender;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  List<String> genderList = ["L", "P"];
  List<Batches> batchList = [];
  List<Datum> trainingList = [];

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      setState(() => isLoading = true);
      final batchResponse = await AuthenticationAPI.getListBatch();
      final trainingResponse = await AuthenticationAPI.getListTraining();
      setState(() {
        batchList = batchResponse.data ?? [];
        trainingList = trainingResponse.data ?? [];
      });
    } catch (e) {
      print("Error fetch dropdown: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load data dropdown: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickFoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
      );
      if (image != null) {
        setState(() => pickedFile = image);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memilih gambar: $e")));
    }
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih jenis kelamin")));
      return;
    }

    if (_selectedPelatihan == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih kategori pelatihan")));
      return;
    }

    if (_selectedBatch == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih batch pelatihan")));
      return;
    }

    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil belum dipilih")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      RegisterUserModel result = await AuthenticationAPI.registerUser(
        name: name,
        email: email,
        password: pass,
        jenisKelamin: selectedGender!,
        profilePhoto: File(pickedFile!.path),
        batchId: _selectedBatch!.id!,
        trainingId: _selectedPelatihan!.id!,
      );

      // Simpan token jika ada
      if (result.data?.token != null) {
        PreferenceHandler.saveToken(result.data!.token!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? "Register berhasil")),
      );

      // Navigasi ke login screen
      context.pushNamed(LoginScreen.id);
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal daftar: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Stack(children: [buildLayer()])),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFF1E293B),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Foto Profil
                          Stack(
                            children: [
                              pickedFile != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(
                                        File(pickedFile!.path),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey[700],
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF60A5FA),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: pickFoto,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: pickFoto,
                            child: const Text(
                              "Select Profile Photo",
                              style: TextStyle(
                                color: Color(0xFF60A5FA),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email
                          buildTitle("Email Address"),
                          const SizedBox(height: 8),
                          buildTextField(
                            hintText: "Enter your email",
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email harus diisi';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Name
                          buildTitle("Name"),
                          const SizedBox(height: 8),
                          buildTextField(
                            hintText: "Enter your name",
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password
                          buildTitle("Password"),
                          const SizedBox(height: 8),
                          buildTextField(
                            hintText: "Enter your password",
                            isPassword: true,
                            controller: passwordController,
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
                          const SizedBox(height: 16),

                          // Gender
                          buildTitle("Gender"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            dropdownColor: const Color(0xFF374151),
                            isExpanded: true,
                            value: selectedGender,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: genderList.map((g) {
                              return DropdownMenuItem(
                                value: g,
                                child: Text(
                                  g == "L" ? "Laki-laki" : "Perempuan",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => selectedGender = val),
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih jenis kelamin';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Dropdown Pelatihan
                          buildTitle("List Trainings"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Datum>(
                            dropdownColor: const Color(0xFF374151),
                            isExpanded: true,
                            value: _selectedPelatihan,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: trainingList.map((pelatihan) {
                              return DropdownMenuItem(
                                value: pelatihan,
                                child: Text(
                                  pelatihan.title ??
                                      "Pelatihan ${pelatihan.id}",
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPelatihan = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih kategori pelatihan';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Dropdown Batch
                          buildTitle("List All Batches"),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Batches>(
                            dropdownColor: const Color(0xFF374151),
                            isExpanded: true,
                            value: _selectedBatch,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: batchList.map((batch) {
                              return DropdownMenuItem(
                                value: batch,
                                child: Text(
                                  batch.batchKe ?? "Batch ${batch.id}",
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBatch = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih batch pelatihan';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1E293B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sign In link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Color(0xFF60A5FA),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !isVisibility : false,
      validator: validator,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF374151),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
              )
            : null,
      ),
    );
  }

  Widget buildTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
