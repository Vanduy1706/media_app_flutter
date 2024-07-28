import 'package:flutter/material.dart';

class SearchResult {
  final String imageFollow;
  final String nameFollowUser;

  SearchResult({required this.imageFollow, required this.nameFollowUser});
}

class SearchResultPage extends StatelessWidget {
  final SearchResult result;

  const SearchResultPage({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(result.imageFollow),
            Text(result.nameFollowUser),
          ],
        ),
      ),
    );
  }
}
