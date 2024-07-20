class PostModel {
  String? postContent;
  String? postImageUrl;
  String? userId;

  PostModel({
    required this.postContent,
    required this.postImageUrl,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postContent: json['postContent'],
    postImageUrl: json['postImageUrl'],
    userId: json['userId'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["postContent"] = postContent;
    data["postImageUrl"] = postImageUrl;
    data["userId"] = userId;

    return data;
  }
}