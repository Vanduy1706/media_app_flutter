import 'package:flutter/material.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/postDetails/post_details_page.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({super.key, required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToPostDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage()),
    );
  }

  void _handleImageTap(String imageUrl) {
    // Xử lý sự kiện khi nhấp vào imageContent
  }

  void _handleLikeTap() {
    // Xử lý sự kiện khi nhấp vào icon like
  }

  void _handleCommentTap() {
    // Xử lý sự kiện khi nhấp vào icon comment
  }

  void _handleShareTap() {
    // Xử lý sự kiện khi nhấp vào icon share
  }

  void _handleBookmarkTap() {
    // Xử lý sự kiện khi nhấp vào icon bookmark
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                leading: GestureDetector(
                  onTap: () => {
                    widget.scaffoldKey.currentState?.openDrawer()
                  },
                  child: const Icon(Icons.account_circle, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
                ),
                title: Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                  width: 24,
                  height: 24,
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () => {},
                    child: const Icon(Icons.settings, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
                  ),
                  SizedBox(width: 10,)
                ],
                centerTitle: true,
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color.fromRGBO(119, 82, 254, 1),
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  tabs: [
                    Tab(
                      child: Text(
                        'Bài đăng',
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Đang theo dõi',
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  PostWidget(
                    userName: "Võ Văn Duy",
                    createdAt: "12Thang6,2025",
                    postContent: "Núi phú sĩ",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg',
                    onPostTap: _navigateToPostDetail,
                    onImageTap: () => _handleImageTap('https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg'),
                    onLikeTap: _handleLikeTap,
                    onCommentTap: _handleCommentTap,
                    onShareTap: _handleShareTap,
                    onBookmarkTap: _handleBookmarkTap,
                  ),
                  PostWidget(
                    userName: "Trần trọng lực",
                    createdAt: "13Thang6,2023",
                    postContent: "Kem nào mà chả là kem 🤡",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://i.imgflip.com/7eb085.jpg',
                    onPostTap: _navigateToPostDetail,
                    onImageTap: () => _handleImageTap('https://i.imgflip.com/7eb085.jpg'),
                    onLikeTap: _handleLikeTap,
                    onCommentTap: _handleCommentTap,
                    onShareTap: _handleShareTap,
                    onBookmarkTap: _handleBookmarkTap,
                  ),
                  // Thêm các PostWidget khác nếu cần
                ],
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  PostWidget(
                    userName: "Anime - My Heart",
                    createdAt: "12Thang6,2003",
                    postContent: "Zen thật sự rất thương ông của mình 😢",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://images.wallpapersden.com/image/download/zenitsu-agatsuma_65696_2880x1800.jpg',
                    onPostTap: _navigateToPostDetail,
                    onImageTap: () => _handleImageTap('https://images.wallpapersden.com/image/download/zenitsu-agatsuma_65696_2880x1800.jpg'),
                    onLikeTap: _handleLikeTap,
                    onCommentTap: _handleCommentTap,
                    onShareTap: _handleShareTap,
                    onBookmarkTap: _handleBookmarkTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
