import 'package:flutter/material.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/comment/widget/comment_widget.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/home/widgets/post_image_detail.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/post_form.dart';
import 'package:media_mobile/features/post/update_post_form.dart';
import 'package:media_mobile/features/postDetails/post_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel user;
  const HomePage({super.key, required this.scaffoldKey, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<FullPostModel>> _futurePosts;
  String id = '';
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _futurePosts = getListPosts();
  }

  Future<List<FullPostModel>> getListPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id').toString();
    return await PostDataSource().getAllPosts(prefs.getString('token').toString());
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _futurePosts = getListPosts();
    });
  }

  void _navigateToPostDetail(FullPostModel post, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          post: post,
          user: user,
          userId: id,
          onOptionTap: () => _showOptions(context, post.postId!),
          onImageTap: () => _handleImageTap(context, post.postImageUrl!),
          onLikeTap: _handleLikeTap,
          onCommentTap: () => _handleCommentTap(post, user),
          onShareTap: _handleShareTap,
          onBookmarkTap: _handleBookmarkTap,
          )
        ),
    );
  }



  void _handleImageTap(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }

  void _handleLikeTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _handleCommentTap(FullPostModel post, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentForm(post: post, user: user)
      )
    );
  }

  void _handleShareTap() {
    // Xử lý sự kiện khi nhấp vào icon share
  }

  void _handleBookmarkTap() {
    // Xử lý sự kiện khi nhấp vào icon bookmark
  }

  void _showOptions(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                title: Text('Chỉnh sửa bài đăng', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostForm(user: widget.user, postId: postId)));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa bài đăng', style: TextStyle(color: Colors.red),),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context, postId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn chắc chắn muốn xóa bài đăng này chứ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deletePost(postId);
              },
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  void _updateLoadingDialog(BuildContext context, IconData icon, Color color, String successMessage, String errorMessage) {
    Navigator.pop(context); // Close the current dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 20),
              Text(icon == Icons.check ? successMessage : errorMessage),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        );
      },
    ).then((_) {
    });
  }

  Future<void> _deletePost(String postId) async {
    _showLoadingDialog(context, 'Đang xóa');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await PostDataSource().deletePost(postId, prefs.getString('id').toString(), prefs.getString('token').toString());
    if(result == true) {
      _updateLoadingDialog(context, Icons.check, Colors.green, 'Xóa thành công!', 'Xóa thất bại!');
      _refreshPosts();
    } else {
      _updateLoadingDialog(context, Icons.close, Colors.red, 'Xóa thành công!', 'Xóa thất bại!');
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                leading: GestureDetector(
                  onTap: () => {
                    widget.scaffoldKey.currentState?.openDrawer()
                  },
                  child: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary, size: 24,),
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
                    child: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary, size: 24,),
                  ),
                  SizedBox(width: 10,)
                ],
                centerTitle: true,
                bottom: TabBar(
                  dividerColor: Theme.of(context).colorScheme.primary,
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
              RefreshIndicator(
                onRefresh: _refreshPosts,
                child: FutureBuilder<List<FullPostModel>>(
                  future: _futurePosts, 
                  builder: (context, postsSnapshot) {
                    if (postsSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!postsSnapshot.hasData || postsSnapshot.data!.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshPosts,
                        child: ListView(
                          children: [
                            Center(child: Text('Không tìm thấy bài đăng nào.')),
                          ],
                        )
                      );
                    }

                    return ListView.builder(
                      itemCount: postsSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = postsSnapshot.data![index];
                        return PostWidget(
                          post: post,
                          id: id,
                          onOptionTap: () => _showOptions(context, post.postId!),
                          onPostTap: () => _navigateToPostDetail(post, widget.user),
                          onImageTap: () => _handleImageTap(context, post.postImageUrl!),
                          onLikeTap: _handleLikeTap,
                          onCommentTap: () => _handleCommentTap(post, widget.user),
                          onShareTap: _handleShareTap,
                          onBookmarkTap: _handleBookmarkTap,
                        );
                      },
                    );
                  },
                ),
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


