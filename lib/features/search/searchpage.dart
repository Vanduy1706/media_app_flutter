import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/resume/profile_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:media_mobile/features/search/search_result.dart';
import 'package:media_mobile/features/search/widgets/recommend.dart';
import 'package:media_mobile/features/search/widgets/search_history.dart';
import 'dart:convert';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/search/search_data_sources.dart';

class SearchPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SearchPage({super.key, required this.scaffoldKey});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  List<UserModel> searchResults = [];
  List<String> searchHistory = [];
  final FocusNode _focusNode = FocusNode();
  final SearchDataSources _searchDataSources = SearchDataSources();
  UserModel currentUser = UserModel.userEmpty(); // Thay thế token của bạn ở đây


  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('searchHistory');
    if (history != null) {
      setState(() {
        searchHistory = history.where((item) {
          final searchDate = DateTime.tryParse(json.decode(item)['date']);
          return searchDate != null &&
              searchDate.isAfter(DateTime.now().subtract(Duration(days: 1)));
        }).take(8).toList();
      });
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    // Kiểm tra sự tồn tại của từ khóa trong lịch sử
    if (!searchHistory.any((item) => json.decode(item)['query'] == query)) {
      searchHistory.insert(0, json.encode({'query': query, 'date': now}));
      searchHistory = searchHistory.take(8).toList();
      await prefs.setStringList('searchHistory', searchHistory);
    }
  }

  Future<void> _deleteSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('searchHistory');
    setState(() {
      searchHistory.clear();
    });
  }

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

  void _updateSearchResults(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUser = await AuthDataSources().currentUser(prefs.getString('token').toString());
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      List<UserModel> users = await _searchDataSources.searchUser(query, prefs.getString('token').toString());
      setState(() {
        searchResults = users.map((user) => UserModel(
          userId: user.userId,
          userName: user.userName,
          decription: user.decription,
          dateOfBirth: user.dateOfBirth,
          phoneNumber: user.phoneNumber,
          address: user.address,
          job: user.job,
          personalImage: user.personalImage,
          backgroundImage: user.backgroundImage,
          createdAt: user.createdAt,
        )).toList();
      });
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  void _onSearchSubmitted(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (query.isEmpty) return;

    try {
      List<UserModel> users = await _searchDataSources.searchUser(query, prefs.getString('token').toString());
      if (users.isNotEmpty) {
        _saveSearchHistory(query);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileUser(user: users.first, currentUser: currentUser,)
            // SearchResultPage(result: SearchResult(
            //   imageFollow: users.first.personalImage!,
            //   nameFollowUser: users.first.userName!
            // )),
          ),
        );
      }
    } catch (e) {
      print('Error searching users: $e');
    }
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            leading: !isSearching
                ? GestureDetector(
                    onTap: () => {widget.scaffoldKey.currentState?.openDrawer()},
                    child: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  )
                : GestureDetector(
                    onTap: _stopSearching,
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.primary,
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
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
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
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          onTap: _startSearching,
                          onChanged: _updateSearchResults,
                          onSubmitted: _onSearchSubmitted,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                        )),
                        !isSearching || _searchController.text.isEmpty
                            ? Icon(Icons.search,
                                color: Theme.of(context).colorScheme.secondary)
                            : GestureDetector(
                                onTap: () => {
                                  _searchController.clear(),
                                  _updateSearchResults('')
                                },
                                child: Icon(Icons.highlight_remove, color: Theme.of(context).colorScheme.secondary,),
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
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.primary,
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
                          child: CachedNetworkImage(
                            imageUrl: result.personalImage!, 
                            progressIndicatorBuilder: (_, url, download) {
                              if(download.progress != null) {
                                return const LinearProgressIndicator();
                              }

                              return Text('Đã tải xong');
                            },
                            cacheManager: CacheManager(
                              Config(
                                'customCacheKey',
                                stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                                maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                              ),
                            ),
                            fit: BoxFit.cover,
                            width: screenWidth * 0.10,
                            height: screenWidth * 0.10,
                          ),
                        ),
                        title: Text(result.userName!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileUser(user: result, currentUser: currentUser,),
                            ),
                          );
                        },
                      )),
                if (!isSearching || searchResults.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lịch sử tìm kiếm',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        if (searchHistory.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
                            onPressed: _deleteSearchHistory,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ...searchHistory.map((item) {
                    final historyItem = json.decode(item);
                    return ListTile(
                      leading: Icon(Icons.history, color: Theme.of(context).colorScheme.secondary,),
                      title: Text(historyItem['query'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),),
                      onTap: () => _onSearchSubmitted(historyItem['query']),
                    );
                  }).toList(),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10),
                  //   child: Text('Đề xuất',
                  //       style: TextStyle(
                  //           color: Theme.of(context).colorScheme.primary,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20)),
                  // ),
                  // Recommend(
                  //   imageFollow:
                  //       'https://i.pinimg.com/736x/d5/91/b6/d591b6d01b26307bcc7b4f0aaa658ad5.jpg',
                  //   nameFollowUser: 'Gojou Satoru',
                  // ),
                  // Recommend(
                  //   imageFollow:
                  //       'https://i.pinimg.com/564x/60/d3/89/60d3891be1db0a41088404ba4f4f1e08.jpg',
                  //   nameFollowUser: 'Nghĩa',
                  // ),
                  // Recommend(
                  //   imageFollow:
                  //       'https://i.pinimg.com/564x/60/d3/89/60d3891be1db0a41088404ba4f4f1e08.jpg',
                  //   nameFollowUser: 'Như Sao',
                  // ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}