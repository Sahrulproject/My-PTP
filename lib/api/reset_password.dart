import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myptp/api/endpoint/endpoint.dart';
import 'package:myptp/models/reset_password_model.dart';

class ResetPasswordAPI {
  static Future<ResetPasswordModel?> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.resetPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp, "password": password}),
      );

      if (response.statusCode == 200) {
        return ResetPasswordModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Gagal reset password: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
