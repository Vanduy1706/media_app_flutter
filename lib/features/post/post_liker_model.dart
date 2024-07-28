class PostLiker {
  String? postId;

  PostLiker({
    required this.postId
  });

  factory PostLiker.fromJson(Map<String, dynamic> json) => PostLiker(
    postId: json['postId'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["postId"] = postId;

    return data;
  }
}