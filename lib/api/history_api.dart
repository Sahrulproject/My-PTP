import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myptp/api/endpoint/endpoint.dart';
import 'package:myptp/models/history_absen_model.dart';
import 'package:myptp/preference/shared_preference.dart';

class HistoryAPI {
  static Future<HistoryModel> getHistory() async {
    final url = Uri.parse(Endpoint.history);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Profile Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return HistoryModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print(error);
      throw Exception(error["message"] ?? "Gagal mengambil profil");
    }
  }
}
