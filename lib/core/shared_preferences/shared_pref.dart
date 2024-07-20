import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:media_mobile/features/authentication/login/login_page.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> saveUser(UserModel objUser) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = jsonEncode(objUser);
    prefs.setString('user', strUser);
    print("Luu thanh cong: $strUser");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> logOut(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', '');
    print("Logout thành công");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

//
Future<UserModel> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String strUser = pref.getString('user')!;
  return UserModel.fromJson(jsonDecode(strUser));
}