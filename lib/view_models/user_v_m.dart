import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:warsha_commerce/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  bool isLoading = false;
  final UserService _userService;
  String token = "-";
  String address = "-";
  String name = "-";
  String phone = "-";
  String email = "-";
  String governorate = "-";


  UserViewModel(this._userService);

  Future<String> login(String username, String password) async {
    String status = "";
    try {
      isLoading = true;
      notifyListeners();

      final response = await _userService.login(username, password);
      if (response.statusCode == 200) {
        status = "logged_in";

        token = jsonDecode(response.body)["token"];
        address = jsonDecode(response.body)["address"];
        name = jsonDecode(response.body)["name"];
        phone = jsonDecode(response.body)["phone"];
        email = jsonDecode(response.body)["email"];
        governorate = jsonDecode(response.body)["governorate"];

        debugPrint("Logged in successfully");
      } else {
        status = "failed_login";
        debugPrint("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      status = "failed_login";
      debugPrint("Error Logging In: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return status;
  }

}