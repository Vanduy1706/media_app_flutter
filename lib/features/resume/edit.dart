import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/comment/widget/comment_widget.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/update_post_form.dart';
import 'package:media_mobile/features/postDetails/post_details_page.dart';
import 'package:media_mobile/features/resume/edit_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserModel user = UserModel.userEmpty();
  late String formattedDate;
  late Future<List<FullPostModel>> getPostByUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getPostByUser = _getPostByUser(user.userId!);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = UserModel.fromJson(jsonDecode(strUser));

    // Chuyển đổi và định dạng ngày tháng
    DateTime utcnow = DateTime.parse(user.createdAt!);
    DateTime localTime = utcnow.toLocal();
    formattedDate = DateFormat('dd/MM/yyyy').format(localTime);
  }

  Future<List<FullPostModel>> _getPostByUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await PostDataSource().getPostByUser(prefs.getString('id').toString(), prefs.getString('token').toString() );
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostForm(user: user, postId: postId)));
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
      // _refreshPosts();
    } else {
      _updateLoadingDialog(context, Icons.close, Colors.red, 'Xóa thành công!', 'Xóa thất bại!');
    }
  }

  void _navigateToPostDetail(FullPostModel post, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          post: post,
          user: user,
          userId: post.userId!,
          onOptionTap: () => _showOptions(context, post.postId!),
          onImageTap: () => _handleImageTap('https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg'),
          onLikeTap: _handleLikeTap,
          onCommentTap: () => _handleCommentTap(post, user),
          onShareTap: _handleShareTap,
          onBookmarkTap: _handleBookmarkTap,
          )
        ),
    );
  }

  void _handleCommentTap(FullPostModel post, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentForm(post: post, user: user)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: getDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildUserProfile(context);
          }
        },
      ),
    );
  }

  Widget buildUserProfile(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: user.backgroundImage != null ? BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(user.backgroundImage!),
                  fit: BoxFit.cover,
                ),
              ) : BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://th.bing.com/th/id/OIP.izuUPw06Klw7NffcjplZ4gHaEK?rs=1&pid=ImgDetMain')
                )
              ),
            ),
            Stack(
              alignment: Alignment.topLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 70,
                ),
                Positioned(
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditResume(user: user)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 30,
                  child: user.personalImage != null ?  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.personalImage!),
                  ) : CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  SizedBox(height: 8),
                  if(user.decription != null)
                  Text(
                    user.decription!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  )
                  else Container(),
                  SizedBox(height: 16),
                  if(user.address != "")
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text(user.address!, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    ],
                  )
                  else Container(),
                  SizedBox(height: 8),
                  if(user.job != "")
                  Row(
                    children: [
                      Icon(Icons.school),
                      SizedBox(width: 8),
                      Text(user.job!, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    ],
                  )
                  else Container(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),
                      Text('Đã tham gia vào ngày $formattedDate', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    'Bài đăng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                  ),
                ),
                Tab(
                  child: Text(
                    'Lượt bình luận',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Bài trả lời',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Lượt thích',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Phương tiện',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Color.fromRGBO(119, 82, 254, 1),
              indicatorPadding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
            ),
            SingleChildScrollView(
              child: Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder<List<FullPostModel>>(
                    future: getPostByUser,
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapShot.hasData) {
                        return Text('Không tìm thấy bài đăng nào.', style: TextStyle(color: Theme.of(context).colorScheme.primary),);
                      }
                      final posts = snapShot.data!;
                      return
                          Column(
                            children: posts.map((post) {
                              return 
                                PostWidget(
                                  post: post,
                                  id: post.userId!,
                                  onOptionTap: () => _showOptions(context, post.postId!),
                                  onPostTap: () => _navigateToPostDetail(post, user),
                                  onImageTap: () => _handleImageTap('https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg'),
                                  onLikeTap: _handleLikeTap,
                                  onCommentTap: () => _handleCommentTap(post, user),
                                  onShareTap: _handleShareTap,
                                  onBookmarkTap: _handleBookmarkTap,
                                );
                            }).toList(),
                          
                          
                        
                      );
                    },
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Lượt bình luận')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Bài viết')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Lượt thích')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Phương tiện')),
                    ],
                  ),
                ],
              ),
            ),
            )
            
          ],
        ),
      ),
    );
  }

  void _handleLikeTap() {}

  void _handleShareTap() {}

  void _handleBookmarkTap() {}

  _handleImageTap(String imageUrl) {}
}
