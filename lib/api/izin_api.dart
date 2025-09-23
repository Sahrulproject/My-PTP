// lib/api/izin_api.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myptp/api/endpoint/endpoint.dart';
import 'package:myptp/models/izin_model.dart';
import 'package:myptp/preference/shared_preference.dart';

class IzinAPI {
  static Future<IzinModel?> postIzin({
    required String date,
    required String alasan,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      if (token == null) {
        print("Token tidak ada");
        return null;
      }

      final response = await http.post(
        Uri.parse(Endpoint.izin),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"date": date, "alasan_izin": alasan}),
      );

      print("Response Izin: ${response.body}");

      if (response.statusCode == 200) {
        return izinModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error postIzin: $e");
      return null;
    }
  }
}
