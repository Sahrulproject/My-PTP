// reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:myptp/api/reset_password.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});
  static const id = "/reset_password_screen";

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? errorMessage;
  String? successMessage;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
        successMessage = null;
      });

      try {
        final response = await ResetPasswordAPI.resetPassword(
          email: widget.email,
          otp: otpController.text.trim(),
          password: newPasswordController.text.trim(),
        );

        setState(() {
          successMessage = response?.message ?? "Password berhasil direset";
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(successMessage!)));

        // Navigate back to login after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Password reset failed: $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: const Color(0xFF2D3748),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Reset password for: ${widget.email}",
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "StageGrotesk_Regular",
                ),
              ),
              const SizedBox(height: 30),

              // Error message
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Success message
              if (successMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    successMessage!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                "Code OTP",
                style: TextStyle(fontSize: 16, fontFamily: "StageGrotesk_Bold"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'OTP code cannot be empty';
                  }
                  if (value.length < 4) {
                    return 'OTP code minimum 4 digits';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_clock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "enter the OTP code",
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "New Password",
                style: TextStyle(fontSize: 16, fontFamily: "StageGrotesk_Bold"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: newPasswordController,
                obscureText: !isNewPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'New password cannot be empty';
                  }
                  if (value.length < 6) {
                    return 'Password minimum 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter a New Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isNewPasswordVisible = !isNewPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Confirm New Password",
                style: TextStyle(fontSize: 16, fontFamily: "StageGrotesk_Bold"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmation password cannot be empty';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Confirmation New Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D3748),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "StageGrotesk_Bold",
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to OTP Verification",
                  style: TextStyle(
                    fontFamily: "StageGrotesk_Regular",
                    color: Color(0xFF1E3A8A),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
