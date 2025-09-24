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

// Definisi warna dan tema terpusat
// Sebaiknya dipindah ke file terpisah agar lebih rapi, misal: app_theme.dart
class AppColors {
  static const Color primary = Color(0xFF2D3748);
  static const Color background = Color(0xFFF9FAFC);
  static const Color textDark = Color(0xFF2D3748);
  static const Color textLight = Colors.white;
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidePassword = true;
  bool isLoading = false;
  String? errorMessage;
  RegisterUserModel? user;

  String? selectedGender;
  Batches? selectedBatch;
  Datum? selectedTraining;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
    }
  }

  Future<void> pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = image;
    });
  }

  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }
    PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");

    if (selectedGender == null ||
        selectedBatch == null ||
        selectedTraining == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih gender, batch, dan training")),
      );
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
        batchId: selectedBatch!.id!,
        trainingId: selectedTraining!.id!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? "Register Success")),
      );
      context.pushNamed(LoginScreen.id);
    } catch (e) {
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Register Failed: $errorMessage")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi tema lokal (bisa dipindah ke MaterialApp di main.dart)
    final theme = ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: "StageGrotesk_Bold",
          fontSize: 20,
          color: AppColors.textDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: "StageGrotesk_Regular",
          color: Colors.grey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: "StageGrotesk_Bold",
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: "StageGrotesk_Bold",
            fontSize: 16,
          ),
        ),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(title: const Text("Registration"), centerTitle: true),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfilePhotoSection(),
                const SizedBox(height: 32),
                _buildTextField("Name", nameController, "Input your full name"),
                const SizedBox(height: 16),
                _buildTextField(
                  "Email",
                  emailController,
                  "Input your email address",
                ),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Gender",
                  genderList
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  selectedGender,
                  (val) => setState(() => selectedGender = val),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Select Batch",
                  batchList
                      .map(
                        (b) => DropdownMenuItem(
                          value: b,
                          child: Text(b.batchKe ?? "Batch ${b.id}"),
                        ),
                      )
                      .toList(),
                  selectedBatch,
                  (val) => setState(() => selectedBatch = val),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Select Training",
                  trainingList
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              t.title ?? "Training ${t.id}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  selectedTraining,
                  (val) => setState(() => selectedTraining = val),
                ),
                const SizedBox(height: 32),
                _buildActionButton(),
                const SizedBox(height: 16),
                _buildLoginSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: pickedFile != null
                  ? FileImage(File(pickedFile!.path)) as ImageProvider
                  : null,
              child: pickedFile == null
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 18,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: pickFoto,
                  tooltip: "Select Profile Photo",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "StageGrotesk_Medium",
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontFamily: "StageGrotesk_Medium",
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passController,
          obscureText: hidePassword,
          decoration: InputDecoration(
            hintText: "Input your password",
            suffixIcon: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => hidePassword = !hidePassword),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
    String label,
    List<DropdownMenuItem<T>> items,
    T? value,
    Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "StageGrotesk_Medium",
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(hintText: "Select $label"),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : registerUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            )
          : const Text(
              "Sign Up",
              style: TextStyle(
                fontFamily: "StageGrotesk_Bold",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            fontFamily: "StageGrotesk_Regular",
            color: AppColors.textDark,
          ),
        ),
        TextButton(
          onPressed: () => context.pushNamed(LoginScreen.id),
          child: const Text(
            "Sign In",
            style: TextStyle(
              fontFamily: "StageGrotesk_Bold",
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
