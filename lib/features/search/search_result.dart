class SearchResult {
  final String imageFollow;
  final String nameFollowUser;

  SearchResult({required this.imageFollow, required this.nameFollowUser});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      imageFollow: json['imageFollow'],
      nameFollowUser: json['nameFollowUser'],
    );
  }
}