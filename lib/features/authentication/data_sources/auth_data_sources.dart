import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_mobile/features/authentication/models/auth_model.dart';
import 'package:media_mobile/features/authentication/models/register_model.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDataSources {
  http.Client client = new http.Client();

  Map<String, String> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token'
    };
  }

  Map<String, String> headerNotoken() {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
  }

  Future<AuthModel> login(String accountName, String accountPassword) async {
    var data = {
      "AccountName": accountName,
      "AccountPassword": accountPassword
    };

    final response = await client.post(
      Uri.parse('https://mediamgmapi.azurewebsites.net/auth/login'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(data)
    );

    var res = json.decode(response.body);

    if(response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = res['token'];
      prefs.setString('token', token);
      prefs.setString('accountName', accountName);
      prefs.setString('id', res['id']);
      
      return AuthModel.fromJson(res);
    } else {
      throw new Exception(res["title"]);
    }

  }

  Future<AuthModel> register(RegisterModel request) async {
    try {
      var data = {
        "userName": request.userName,
        "accountName": request.accountName,
        "accountPassword": request.accountPassword,
        "confirmAccountPassword": request.confirmPassword,
      };

      final response = await client.post(
        Uri.parse('https://mediamgmapi.azurewebsites.net/auth/register'),
        headers: headerNotoken(),
        body: jsonEncode(data),
      );

      var res = json.decode(response.body);

      if(response.statusCode == 200){
        return AuthModel.fromJson(res);
      } else {
        throw new Exception('Failed to register');
      }
    } catch (e) {
      throw new Exception('Failed to register');
    }
  }
  
  Future<UserModel> currentUser(String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/users/current'),
      headers: header(token),
    );

    var res = json.decode(response.body);

    if(response.statusCode == 200) {
      return UserModel.fromJson(res);
    } else {
      throw new Exception(response.reasonPhrase);
    }
  }
}