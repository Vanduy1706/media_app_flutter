import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/post/post_liker_model.dart';
import 'package:media_mobile/features/post/post_model.dart';
class PostDataSource {
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

  Future<bool> createPost(PostModel postBody, String token) async {
    var data = {
      "postId": "",
      "postContent": postBody.postContent,
      "postImageUrl": postBody.postImageUrl,
      "postVideoUrl": postBody.postVideoUrl,
      "postFileUrl": "",
      "postTotalLikes": 0,
      "postTotalComments": 0,
      "postTotalShares": 0,
      "postTotalMarks": 0,
      "userId": postBody.userId,
      "replyId": ""
    };

    final response = await client.post(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts'),
      body: jsonEncode(data),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      print('Thành công');
      return true;
    } else {
      print('Thất bại');
      return false;
    }
  }

  Future<List<FullPostModel>> getAllPosts(String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      
      return res.map((post) => FullPostModel.fromJson(post))
                .cast<FullPostModel>()
                .toList();
    } else {
      var res = json.decode(response.body);
      
      return res.map((post) => FullPostModel.fromJson(post))
                .cast<FullPostModel>()
                .toList(); 
    }
  }

  Future<bool> updatePost(FullPostModel post, String token) async {
    var data = {
      "postId": post.postId,
      "postContent": post.postContent,
      "postImageUrl": post.postImageUrl,
      "postVideoUrl": post.postVideoUrl,
      "postFileUrl": "",
      "postTotalLikes": post.postTotalLikes ?? '',
      "postTotalComments": post.postTotalComments ?? '',
      "postTotalShares": post.postTotalShares ?? '',
      "postTotalMarks": post.postTotalMarks ?? '',
      "userId": post.userId,
      "replyId": post.replyId ?? '',
    };

    final response = await client.patch(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts'),
      body: jsonEncode(data),
      headers: header(token)
    );

    if(response.statusCode == 204) {
      print('Cập nhật thành công');
      return true;
    } else {
      print('Cập nhật thất bại');
      return false;
    }
  }

  Future<FullPostModel> getPost(String postId, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/$postId'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      return FullPostModel.fromJson(res);
    } else {
      throw new Exception('Invalid');
    }
  }

  Future<bool> deletePost(String postId, String userId, String token) async {
    final response = await client.delete(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/$postId/users/$userId'),
      headers: header(token)
    );

    if(response.statusCode == 204) {
      print('Đã xóa');
      return true;
    } else {
      print('Xóa thất bại');
      return false;
    }
  }

  Future<List<FullPostModel>> getComments(String postId, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/comment/$postId'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);

      return res.map((comment) => FullPostModel.fromJson(comment))
                .cast<FullPostModel>()
                .toList();
    } else {
      throw new Exception('Lỗi hệ thống');
    }
  }

  Future<bool> createComment(FullPostModel comment, String token) async {
    var data = {
      "postId": "",
      "postContent": comment.postContent,
      "postImageUrl": comment.postImageUrl,
      "postVideoUrl": comment.postVideoUrl,
      "postFileUrl": "",
      "postTotalLikes": 0,
      "postTotalComments": 0,
      "postTotalShares": 0,
      "postTotalMarks": 0,
      "userId": comment.userId,
      "replyId": comment.replyId
    };

    final response = await client.post(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/comment'),
      body: jsonEncode(data),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      print('Thành công');
      return true;
    } else {
      print('Thất bại');
      return false;
    }
  }

  Future<String> likePost(String postId, String userId, String token) async {
    var data = {
      "postId": postId,
      "userId": userId,
    };
    
    final response = await client.post(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/like'),
      body: jsonEncode(data),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      return res['postTotalLikes'].toString();
    } else {
      throw new Exception(response.statusCode);
    }
  }

  Future<String> disLikePost(String postId, String userId, String token) async {
    var data = {
      "postId": postId,
      "userId": userId
    };
    
    final response = await client.delete(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/dislike'),
      body: jsonEncode(data),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);
      return res['postTotalLikes'].toString();
    } else {
      print('dislike thất bại');
      throw new Exception(response.statusCode);
    }
  }

  Future<bool> getLiker(String userId, String postId, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/liker/$userId/$postId'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<FullPostModel>> getPostByUser(String userId, String token) async {
    final response = await client.get(
      Uri.parse('https://mediamgmapi.azurewebsites.net/posts/$userId/users'),
      headers: header(token)
    );

    if(response.statusCode == 200) {
      var res = json.decode(response.body);

      return res.map((post) => FullPostModel.fromJson(post))
                .cast<FullPostModel>()
                .toList();
    } else {
      throw new Exception(response.reasonPhrase);
    }
  }
}