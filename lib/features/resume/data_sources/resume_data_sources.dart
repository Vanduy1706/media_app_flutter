import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/resume/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeDataSource {
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

  Future<String> uploadFile(String path, String token) async {
    if(path == null) return '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://mediamgmapi.azurewebsites.net/files/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', path));

    request.headers['Authorization'] = 'Bearer $token';

    var res = await request.send();

    if(res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var responseBody = await res.stream.bytesToString();
      var responseJson = await jsonDecode(responseBody);
      var url = responseJson['url'];
      var fileName = responseJson['fileName'];
      

      print('Upload thành công: $url');
      return url;
    } else {
      var responseBody = await res.stream.bytesToString();
      print('Upload thất bại với mã trạng thái: ${res.statusCode}');
      print('Nội dung phản hồi: $responseBody');
      return '';
    }
  }

  Future<bool> changeProfile(ProfileModel profile, String userId, String token) async {
    var data = {
      "userId": userId,
      "userName": profile.userName,
      "decription": profile.description,
      "dateOfBirth": "",
      "phoneNumber": "",
      "address": profile.address,
      "job": profile.job,
      "personalImage": profile.personalImage,
      "backgroundImage": profile.backgroundImage
    };

    final response = await client.patch(
      Uri.parse('https://mediamgmapi.azurewebsites.net/users/profile'),
      headers: header(token),
      body: jsonEncode(data),
    );

    if(response.statusCode == 200) {
      print('Thay đổi thành công!');
      return true;
    } else {
      print('Thay đổi thất bại');
      return false;
    }
  }

  Future<UserModel> getProfileUser(String userId, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/users/profile/$userId'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      return UserModel.fromJson(res);
    } else {
      throw new Exception(response.reasonPhrase);
    }
  }
}