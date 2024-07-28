import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_mobile/features/authentication/models/user_model.dart';

class SearchDataSources {
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

  Future<List<UserModel>> searchUser(String userName, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/users/followers/search?username=$userName'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      return res.map((user) => UserModel.fromJson(user))
                .cast<UserModel>()
                .toList();
    } else {
      throw new Exception(response.reasonPhrase);
    }
  }
}