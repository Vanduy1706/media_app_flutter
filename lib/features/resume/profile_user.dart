import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/comment/widget/comment_widget.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/home/widgets/post_image_detail.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/update_post_form.dart';
import 'package:media_mobile/features/postDetails/post_details_page.dart';
import 'package:media_mobile/features/resume/edit_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUser extends StatefulWidget {
  final UserModel user;
  final UserModel currentUser;
  const ProfileUser({super.key, required this.user, required this.currentUser});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String formattedDate;
  late Future<List<FullPostModel>> getPostByUser;
  late String id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getPostByUser = _getPostByUser(widget.user.userId!);
    format();
  }

  void format() {
    DateTime utcnow = DateTime.parse(widget.user.createdAt!);
    DateTime localTime = utcnow.toLocal();
    formattedDate = DateFormat('dd/MM/yyyy').format(localTime);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<FullPostModel>> _getPostByUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id').toString();
    return await PostDataSource().getPostByUser(userId, prefs.getString('token').toString() );
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
      body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.user.backgroundImage != null
                    ? CachedNetworkImage(
                        imageUrl: widget.user.backgroundImage!, 
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
                        fit: BoxFit.cover
                      )
                    : CachedNetworkImage(
                        imageUrl: 'https://th.bing.com/th/id/OIP.izuUPw06Klw7NffcjplZ4gHaEK?rs=1&pid=ImgDetMain',
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
                      ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: widget.user.personalImage != null
                          ? CachedNetworkImageProvider(
                              widget.user.personalImage!,
                              cacheManager: CacheManager(
                                Config(
                                  'customCacheKey',
                                  stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                                  maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                                ),
                              ),
                            )
                          : CachedNetworkImageProvider(
                              'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                              cacheManager: CacheManager(
                                Config(
                                  'customCacheKey',
                                  stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                                  maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.topLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 40,
                ),
                if(widget.currentUser != widget.user.userId)
                Positioned(
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      'Theo dõi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
                else 
                Positioned(
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditResume(user: widget.user)),
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
              ],
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.userName!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                        SizedBox(height: 8),
                        if(widget.user.decription != null)
                        Text(
                          widget.user.decription!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary
                          ),
                        )
                        else Container(),
                        SizedBox(height: 16),
                        if(widget.user.address != "")
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 8),
                            Text(widget.user.address!, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                          ],
                        )
                        else Container(),
                        SizedBox(height: 8),
                        if(widget.user.job != "")
                        Row(
                          children: [
                            Icon(Icons.school),
                            SizedBox(width: 8),
                            Text(widget.user.job!, style: TextStyle(color: Theme.of(context).colorScheme.primary),),
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
                  SizedBox(height: 8),
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
                ],
              ),
            
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<FullPostModel>>(
            future: getPostByUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bài viết nào.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => {},
                      child: PostWidget(
                        post: snapshot.data![index],
                        onOptionTap: () => _showOptions(context, snapshot.data![index].postId!),
                        onImageTap: () => _handleImageTap(context, snapshot.data![index].postImageUrl!),
                        onLikeTap: _handleLikeTap,
                        onCommentTap: () => _handleCommentTap(snapshot.data![index], widget.currentUser),
                        onShareTap: _handleShareTap,
                        onBookmarkTap: _handleBookmarkTap, onPostTap: () => _navigateToPostDetail(snapshot.data![index], widget.currentUser), id: id,
                      ),
                    );
                  },
                );
              }
            },
          ),
          FutureBuilder<List<FullPostModel>>(
            future: getPostByUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bài viết nào.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if(snapshot.data![index].postTotalComments == '0') {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () => {},
                      child: PostWidget(
                        post: snapshot.data![index],
                        onOptionTap: () => _showOptions(context, snapshot.data![index].postId!),
                        onImageTap: () => _handleImageTap(context, snapshot.data![index].postImageUrl!),
                        onLikeTap: _handleLikeTap,
                        onCommentTap: () => _handleCommentTap(snapshot.data![index], widget.currentUser),
                        onShareTap: _handleShareTap,
                        onBookmarkTap: _handleBookmarkTap, onPostTap: () => _navigateToPostDetail(snapshot.data![index], widget.currentUser), id: id,
                      ),
                    );
                  },
                );
              }
            },
          ),
          FutureBuilder<List<FullPostModel>>(
            future: getPostByUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bài viết nào.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if(snapshot.data![index].replyId == null) {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () => {},
                      child: PostWidget(
                        post: snapshot.data![index],
                        onOptionTap: () => _showOptions(context, snapshot.data![index].postId!),
                        onImageTap: () => _handleImageTap(context, snapshot.data![index].postImageUrl!),
                        onLikeTap: _handleLikeTap,
                        onCommentTap: () => _handleCommentTap(snapshot.data![index], widget.currentUser),
                        onShareTap: _handleShareTap,
                        onBookmarkTap: _handleBookmarkTap, onPostTap: () => _navigateToPostDetail(snapshot.data![index], widget.currentUser), id: id,
                      ),
                    );
                  },
                );
              }
            },
          ),
          FutureBuilder<List<FullPostModel>>(
            future: getPostByUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Không tìm thấy bài viết nào'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bài viết nào.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if(snapshot.data![index].postTotalLikes == '0') {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () => {},
                      child: PostWidget(
                        post: snapshot.data![index],
                        onOptionTap: () => _showOptions(context, snapshot.data![index].postId!),
                        onImageTap: () => _handleImageTap(context, snapshot.data![index].postImageUrl!),
                        onLikeTap: _handleLikeTap,
                        onCommentTap: () => _handleCommentTap(snapshot.data![index], widget.currentUser),
                        onShareTap: _handleShareTap,
                        onBookmarkTap: _handleBookmarkTap, 
                        onPostTap: () => _navigateToPostDetail(snapshot.data![index], widget.currentUser), id: id,
                      ),
                    );
                  },
                );
              }
            },
          ),
          Center(child: Text('Phương tiện')),
        ],
      ),
    )
    );
  }


  void _handleLikeTap() {}


  void _handleShareTap() {}

  void _handleBookmarkTap() {}

  void _handleImageTap(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }
}
