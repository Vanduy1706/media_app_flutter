class FullPostModel {
  String? postId;
  String? postContent;
  String? postImageUrl;
  String? postVideoUrl;
  String? postFileUrl;
  String? postTotalLikes;
  String? postTotalComments;
  String? postTotalShares;
  String? postTotalMarks;
  String? userId;
  String? userName;
  String? imageUser;
  String? replyId;
  String? replierName;
  String? createdAt;

  FullPostModel({
    required this.postId,
    required this.postContent,
    required this.postImageUrl,
    required this.postVideoUrl,
    required this.postFileUrl,
    required this.postTotalLikes,
    required this.postTotalComments,
    required this.postTotalShares,
    required this.postTotalMarks,
    required this.userId,
    required this.userName,
    required this.imageUser,
    required this.replyId,
    required this.replierName,
    required this.createdAt,
  });

  factory FullPostModel.fromJson(Map<String, dynamic> json) => FullPostModel(
    postId: json["postId"],
    postContent: json["postContent"],
    postImageUrl: json["postImageUrl"],
    postVideoUrl: json["postVideoUrl"],
    postFileUrl: json["postFileUrl"],
    postTotalLikes: json["postTotalLikes"].toString(),
    postTotalComments: json["postTotalComments"].toString(),
    postTotalShares: json["postTotalShares"].toString(),
    postTotalMarks: json["postTotalMarks"].toString(),
    userId: json["userId"],
    userName: json["userName"],
    imageUser: json["imageUser"],
    replyId: json["replyId"],
    replierName: json["replierName"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["postId"] = postId;
    data["postContent"] = postContent;
    data["postImageUrl"] = postImageUrl;
    data["postVideoUrl"] = postVideoUrl;
    data["postFileUrl"] = postFileUrl;
    data["postTotalLikes"] = postTotalLikes;
    data["postTotalComments"] = postTotalComments;
    data["postTotalShares"] = postTotalShares;
    data["postTotalMarks"] = postTotalMarks;
    data["userId"] = userId;
    data["userName"] = userName;
    data["imageUser"] = imageUser;
    data["replyId"] = replyId;
    data["replierName"] = replierName;
    data["createdAt"] = createdAt;

    return data;
  }
}