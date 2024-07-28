class PostModel {
  String? postContent;
  String? postImageUrl;
  String? postVideoUrl;
  String? userId;

  PostModel({
    required this.postContent,
    required this.postImageUrl,
    required this.postVideoUrl,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postContent: json['postContent'],
    postImageUrl: json['postImageUrl'],
    userId: json['userId'], 
    postVideoUrl: json['postVideoUrl'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["postContent"] = postContent;
    data["postImageUrl"] = postImageUrl;
    data["postVideoUrl"] = postVideoUrl;
    data["userId"] = userId;
    

    return data;
  }
}