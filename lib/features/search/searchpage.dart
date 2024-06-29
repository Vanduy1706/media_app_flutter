import 'package:flutter/material.dart';
import 'package:media_mobile/features/search/search_result.dart';
import 'package:media_mobile/features/search/widgets/recommend.dart';
import 'package:media_mobile/features/search/widgets/search_history.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchPage({super.key, required this.scaffoldKey});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  List<SearchResult> searchResults = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startSearching() {
    setState(() {
      isSearching = true;
      _focusNode.requestFocus();
    });
  }

  void _stopSearching() {
    setState(() {
      _focusNode.unfocus();
      isSearching = false;
      searchResults.clear();
    });
  }

  void _updateSearchResults(String query) {
    // Ví dụ mảng JSON giả lập
    String jsonResponse = '''
    [
      {
        "imageFollow": "https://i.pinimg.com/564x/51/91/4f/51914fe23c96ea0e951bcd548417709b.jpg",
        "nameFollowUser": "Trần Thị Yến Nhi"
      },
      {
        "imageFollow": "https://i.pinimg.com/736x/a1/32/f8/a132f8354f89e6d35c474b0f7e167d56.jpg",
        "nameFollowUser": "Võ Phương Thảo"
      },
      {
        "imageFollow": "https://i.pinimg.com/564x/11/a8/a7/11a8a76b8022e90bd30567316a113a3a.jpg",
        "nameFollowUser": "Lý Gia Hân"
      }
    ]
    ''';

    List<dynamic> jsonResults = json.decode(jsonResponse);

    setState(() {
      searchResults = jsonResults.map((json) => SearchResult.fromJson(json)).toList();
    });
  }

  Future<bool> _onWillPop() async {
    if (isSearching) {
      _stopSearching();
      return false; // Ngăn chặn việc thoát khỏi trang
    }
    return true; // Cho phép thoát khỏi trang
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Color.fromRGBO(244, 244, 244, 1),
            leading: !isSearching
                ? GestureDetector(
                    onTap: () => {widget.scaffoldKey.currentState?.openDrawer()},
                    child: const Icon(
                      Icons.account_circle,
                      color: Color.fromRGBO(38, 37, 43, 1),
                      size: 24,
                    ),
                  )
                : GestureDetector(
                    onTap: _stopSearching,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(38, 37, 43, 1),
                      size: 24,
                    ),
                  ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: !isSearching
                          ? Color.fromRGBO(233, 233, 234, 1)
                          : Color.fromRGBO(244, 244, 244, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm ở đây',
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(201, 200, 202, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1)),
                          onTap: _startSearching,
                          onChanged: _updateSearchResults,
                        )),
                        !isSearching || _searchController.text.isEmpty
                            ? Icon(Icons.search,
                                color: Color.fromRGBO(201, 200, 202, 1))
                            : GestureDetector(
                                onTap: () => {
                                  _searchController.clear(),
                                  _updateSearchResults('')
                                },
                                child: Icon(Icons.highlight_remove),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: !isSearching
                ? <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.settings,
                        color: Color.fromRGBO(38, 37, 43, 1),
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ]
                : null,
            centerTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSearching && searchResults.isNotEmpty)
                  ...searchResults.map((result) => ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            result.imageFollow, 
                            fit: BoxFit.cover,
                            width: screenWidth * 0.10,
                            height: screenWidth * 0.10,
                          ),
                        ),
                        title: Text(result.nameFollowUser),
                        
                      )),
                if (!isSearching || searchResults.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Lịch sử tìm kiếm',
                        style: TextStyle(
                            color: Color.fromRGBO(38, 37, 43, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  SizedBox(height: 10),
                  SearchHistory(inputSearch: 'Võ Văn Duy'),
                  SearchHistory(inputSearch: 'Trần Văn Nghĩa'),
                  SearchHistory(inputSearch: 'Thị Sương'),
                  SearchHistory(inputSearch: 'Trần Quốc Toản'),
                  SearchHistory(inputSearch: 'Lương Cao Bằng'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Đề xuất',
                        style: TextStyle(
                            color: Color.fromRGBO(38, 37, 43, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  Recommend(
                    imageFollow:
                        'https://i.pinimg.com/736x/d5/91/b6/d591b6d01b26307bcc7b4f0aaa658ad5.jpg',
                    nameFollowUser: 'Gojou Satoru',
                  ),
                  Recommend(
                    imageFollow:
                        'https://i.pinimg.com/564x/60/d3/89/60d3891be1db0a41088404ba4f4f1e08.jpg',
                    nameFollowUser: 'Nghĩa',
                  ),
                  Recommend(
                    imageFollow:
                        'https://i.pinimg.com/564x/60/d3/89/60d3891be1db0a41088404ba4f4f1e08.jpg',
                    nameFollowUser: 'Như Sao',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}