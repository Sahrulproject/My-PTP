// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:myptp/api/endpoint/endpoint.dart';
// import 'package:myptp/models/list_batches_model.dart';
// import 'package:myptp/models/list_training_model.dart';
// import 'package:myptp/models/login_model.dart';
// import 'package:myptp/models/register_model.dart';
// import 'package:myptp/preference/shared_preference.dart';

// class AuthenticationAPI {
//   static Future<RegisterUserModel> registerUser({
//     required String name,
//     required String email,
//     required String password,
//     required String jenisKelamin,
//     required File profilePhoto,
//     required int batchId,
//     required int trainingId,
//   }) async {
//     final url = Uri.parse(Endpoint.register);
//     final readImage = profilePhoto.readAsBytesSync();
//     final b64 = base64Encode(readImage);
//     final imageWithPrefix = "data:image/png;base64,$b64";
//     final response = await http.post(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "name": name,
//         "email": email,
//         "password": password,
//         "jenis_kelamin": jenisKelamin,
//         "profile_photo": imageWithPrefix,
//         "batch_id": batchId,
//         "training_id": trainingId,
//       }),
//     );

//     print("STATUS: ${response.statusCode}");
//     print("BODY: ${response.body}");

//     if (response.statusCode == 200) {
//       return RegisterUserModel.fromJson(json.decode(response.body));
//     } else {
//       final error = json.decode(response.body);
//       throw Exception(error["message"] ?? "Failed to Register");
//     }
//   }

//   static Future<LoginModel> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     final url = Uri.parse(Endpoint.login);
//     final response = await http.post(
//       url,
//       body: {"email": email, "password": password},
//       headers: {"Accept": "application/json"},
//     );

//     print("Login Response: ${response.body}");

//     if (response.statusCode == 200) {
//       return LoginModel.fromJson(json.decode(response.body));
//     } else {
//       final error = json.decode(response.body);
//       throw Exception(error["message"] ?? "Login gagal");
//     }
//   }

//   static Future<ListTrainingModel> getListTraining() async {
//     final url = Uri.parse(Endpoint.training);
//     final token = await PreferenceHandler.getToken();

//     final response = await http.get(
//       url,
//       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//     );

//     if (response.statusCode == 200) {
//       return ListTrainingModel.fromJson(json.decode(response.body));
//     } else {
//       final error = json.decode(response.body);
//       throw Exception(error["message"] ?? "Gagal mengambil data layanan");
//     }
//   }

//   static Future<ListBatchesModel> getListBatch() async {
//     final url = Uri.parse(Endpoint.batch);
//     final token = await PreferenceHandler.getToken();

//     final response = await http.get(
//       url,
//       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
//     );

//     if (response.statusCode == 200) {
//       return ListBatchesModel.fromJson(json.decode(response.body));
//     } else {
//       final error = json.decode(response.body);
//       throw Exception(error["message"] ?? "Gagal mengambil data layanan");
//     }
//   }
// }

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:myptp/api/endpoint/endpoint.dart';
import 'package:myptp/models/list_batches_model.dart';
import 'package:myptp/models/list_training_model.dart';
import 'package:myptp/models/login_model.dart';
import 'package:myptp/models/register_model.dart';
import 'package:myptp/preference/shared_preference.dart';

class AuthenticationAPI {
  static Future<RegisterUserModel> registerUser({
    required String name,
    required String email,
    required String password,
    required String jenisKelamin,
    required File profilePhoto,
    required int batchId,
    required int trainingId,
  }) async {
    try {
      final url = Uri.parse(Endpoint.register);
      final readImage = await profilePhoto.readAsBytes();
      final b64 = base64Encode(readImage);
      final imageWithPrefix = "data:image/png;base64,$b64";

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "jenis_kelamin": jenisKelamin,
          "profile_photo": imageWithPrefix,
          "batch_id": batchId,
          "training_id": trainingId,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterUserModel.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ??
              "Failed to Register. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Register Error: $e");
      throw Exception("Network error: $e");
    }
  }

  static Future<LoginModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(Endpoint.login);
      final response = await http.post(
        url,
        body: {"email": email, "password": password},
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      print("Login Status: ${response.statusCode}");
      print("Login Response: ${response.body}");

      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(json.decode(response.body));

        // Simpan token jika login berhasil
        if (loginModel.data?.token != null) {
          await PreferenceHandler.saveToken(loginModel.data!.token!);
          await PreferenceHandler.saveLogin();
        }

        return loginModel;
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ?? "Login gagal. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Login Error: $e");
      throw Exception("Network error: $e");
    }
  }

  static Future<ListTrainingModel> getListTraining() async {
    try {
      final url = Uri.parse(Endpoint.training);
      final token = await PreferenceHandler.getToken();

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Training Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return ListTrainingModel.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ??
              "Gagal mengambil data training. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Training Error: $e");
      throw Exception("Network error: $e");
    }
  }

  static Future<ListBatchesModel> getListBatch() async {
    try {
      final url = Uri.parse(Endpoint.batch);
      final token = await PreferenceHandler.getToken();

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Batch Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return ListBatchesModel.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ??
              "Gagal mengambil data batch. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Batch Error: $e");
      throw Exception("Network error: $e");
    }
  }
}
