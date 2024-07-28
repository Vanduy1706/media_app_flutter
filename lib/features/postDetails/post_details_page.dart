import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/comment/widget/comment_widget.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/home/widgets/post_image_detail.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/update_post_form.dart';
import 'package:media_mobile/features/postDetails/post_content_page.dart';
import 'package:media_mobile/features/resume/data_sources/resume_data_sources.dart';
import 'package:media_mobile/features/resume/profile_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class PostDetailPage extends StatefulWidget {
  final FullPostModel post;
  final VoidCallback onOptionTap;
  final VoidCallback onImageTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;
  final String userId;
  final UserModel user;
  const PostDetailPage({super.key, required this.post, required this.userId, required this.onOptionTap, required this.onImageTap, required this.onLikeTap, required this.onCommentTap, required this.onShareTap, required this.onBookmarkTap, required this.user});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  String id = '';
  bool _isLiked = false;
  String liked = '0';
  UserModel user = UserModel.userEmpty();
  late Future<bool> getLiker;
  late Future<FullPostModel> loadPost;
  late Future<List<FullPostModel>> loadCommentList;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    loadCommentList = _loadCommentList();
    loadPost = _loadPost();
    getLiker = _getLikers();
    if (widget.post.postVideoUrl!.isNotEmpty) {
    // ignore: deprecated_member_use
      _videoController = VideoPlayerController.network(widget.post.postVideoUrl!)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  void _clearMedia() {
    setState(() {
      widget.post.postVideoUrl = '';
      _videoController?.dispose();
      _videoController = null;
    });
  }

  Future<bool> _getLikers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLiked = await PostDataSource().getLiker(id, widget.post.postId!,prefs.getString('token').toString());
    return isLiked;
  }

  Future<void> _refreshComment() async {
    setState(() {
      loadCommentList = _loadCommentList();
    });
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    liked = await PostDataSource().likePost(widget.post.postId!, id, prefs.getString('token').toString());
    setState(() {
      widget.post.postTotalLikes = liked;
    });
  }

  void _toggleDisLike() async {
    setState(() {
      _isLiked = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    liked = await PostDataSource().disLikePost(widget.post.postId!, id, prefs.getString('token').toString());
    setState(() {
      widget.post.postTotalLikes = liked;
    });
  }

  Future<FullPostModel> _loadPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await PostDataSource().getPost(widget.post.postId!, prefs.getString('token').toString());
  }

  Future<List<FullPostModel>> _loadCommentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id').toString();
    return await PostDataSource().getComments(widget.post.postId!, prefs.getString('token').toString());
  }

  String _formatDate(DateTime createdAt) {
    Duration difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(createdAt);
    }
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

  Future<UserModel> getProfileUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await ResumeDataSource().getProfileUser(userId, prefs.getString('token').toString());
    var currentUser = await AuthDataSources().currentUser(prefs.getString('token').toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileUser(user: user, currentUser: currentUser,))
    );
    return user;
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
    // Xử lý sự kiện khi nhấp vào icon like
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

  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  DateTime utcnow = DateTime.parse(widget.post.createdAt!);
  String formattedDate = _formatDate(utcnow);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pop(context)
          },
        ),
        title: Text('Bài đăng', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 20),),
      ),
      body: FutureBuilder<FullPostModel>(
        future: loadPost,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!postSnapshot.hasData) {
            return Center(child: Text('Không tìm thấy bài đăng nào.'));
          }
          final post = postSnapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),// 2.5% of screen width
                  padding: EdgeInsets.all(screenHeight * 0.015),
                  decoration: BoxDecoration(    
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1,
                      ),
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1
                      )
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => getProfileUser(widget.post.userId!),
                              child: Container(
                                child: Row(
                                  children: [
                                    if (widget.post.imageUser != null)
                                      Padding(
                                        padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: widget.post.imageUser!,
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
                                            width: screenWidth * 0.11, // 11% of screen width
                                            height: screenWidth * 0.11,// 11% of screen width
                                          ),
                                        ),
                                      ) else Padding(
                                        padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: 'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                                            fit: BoxFit.cover,
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
                                            width: screenWidth * 0.11, // 11% of screen width
                                            height: screenWidth * 0.11, // 11% of screen width
                                          ),
                                        ),
                                      ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: screenHeight * 0.007), // 0.7% of screen height
                                          child: Text(
                                            widget.post.userName!,
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04, // 4% of screen width
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenWidth * 0.035, // 3.5% of screen width
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(widget.userId != post.userId)
                            ElevatedButton(
                              onPressed: () => {
      
                              }, 
                              child: Text(
                                'Theo dõi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.04, // 4% of screen width as font size
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            if (widget.userId == post.userId) 
                            GestureDetector(
                              onTap: widget.onOptionTap,
                              child: Icon(
                                Icons.more_horiz,
                                color: Theme.of(context).colorScheme.primary,
                                size: screenWidth * 0.06, // 6% of screen width
                              ),
                            ) else Container(),
                          ],
                        ),
                      ),
                      if(post.replierName != null)
                        Row(
                          children: [
                            Text(
                              'Đang trả lời',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.04, // 4% of screen width
                              ),
                            ),
                            SizedBox(width: 4,),
                            Flexible(
                              child: Text(
                                post.replierName!,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04, // 4% of screen width
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else Container(),
                      if (post.postContent != "") 
                        PostContentWidget(
                          postContent: post.postContent!,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        )
                      else 
                        Container(),

                      if (post.postImageUrl != "") 
                        GestureDetector(
                        onTap: widget.onImageTap,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
                          child: CachedNetworkImage(
                            imageUrl: widget.post.postImageUrl!,
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
                            width: screenWidth * 0.95, // 95% of screen width
                            height: screenHeight * 0.45, 
                          ),
                        ),
                      ) 
                        else if (post.postVideoUrl != '' && _isVideoInitialized)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.95,
                          maxHeight: screenHeight * 0.45
                        ),
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                            child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                          ),
                        )
                      )
                      else if (widget.post.postVideoUrl != '' && !_isVideoInitialized)
                        Container(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              width: 1,
                            ),
                            
                          ),
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(post.postTotalLikes!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(width: 5,),
                                Text('Lượt thích', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Row(
                              children: [
                                Text(post.postTotalComments!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(width: 5,),
                                Text('Lượt bình luận', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              width: 1,
                            ),
                            
                          ),
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(post.postTotalShares!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(width: 5,),
                                Text('Bài đăng lại', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Row(
                              children: [
                                Text(post.postTotalMarks!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                SizedBox(width: 5,),
                                Text('Dấu trang', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: getLiker,
                                builder: (context, snapShot) {
                                  if(snapShot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  }

                                  return GestureDetector(
                                    onTap: _isLiked || snapShot.data! ? _toggleDisLike : _toggleLike,
                                    child: Row(
                                      children: [
                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 200),
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            return ScaleTransition(child: child, scale: animation);
                                          },
                                          child: Icon(
                                            _isLiked || snapShot.data! ? Icons.favorite : Icons.favorite_border,
                                            key: ValueKey<bool>(_isLiked || snapShot.data!),
                                            color: _isLiked || snapShot.data! ? Colors.red : Theme.of(context).colorScheme.primary,
                                            size: screenWidth * 0.06, // 6% of screen width
                                          ),
                                        ),
                                      
                                      SizedBox(width: screenWidth * 0.01), // 1% of screen width
                                        Text(
                                          widget.post.postTotalLikes == "0" && liked == "0" ? "" : liked == "0" ? widget.post.postTotalLikes! : liked,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035, // 3.5% of screen width
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.05), // 5% of screen width
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: widget.onCommentTap,
                                child: SvgPicture.asset(
                                  'assets/icons/chat-square-text.svg',
                                  width: screenWidth * 0.06, // 6% of screen width
                                  height: screenWidth * 0.06, // 6% of screen width
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.01), // 1% of screen width
                              if(post.postTotalComments != '0')
                                Text(
                                  post.postTotalComments!,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035, // 3.5% of screen width
                                  ),
                                )
                              else Container(),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.05), // 5% of screen width
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: widget.onShareTap,
                                child: Icon(
                                  Icons.share,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: screenWidth * 0.06, // 6% of screen width
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.01), // 1% of screen width
                              if(post.postTotalShares != '0')
                                Text(
                                  post.postTotalShares!,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035, // 3.5% of screen width
                                  ),
                                )
                              else Container(),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.05), // 5% of screen width
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: widget.onBookmarkTap,
                                child: Icon(
                                  Icons.bookmark,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: screenWidth * 0.06, // 6% of screen width
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.01), // 1% of screen width
                              if(post.postTotalMarks != '0')
                                Text(
                                  post.postTotalMarks!,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035, // 3.5% of screen width
                                  ),
                                )
                              else Container(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                
                ),
                RefreshIndicator(
                  onRefresh: _refreshComment,
                  child: FutureBuilder<List<FullPostModel>>(
                  future: loadCommentList,
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!commentSnapshot.hasData) {
                      return Text('Không tìm thấy bình luận nào.', style: TextStyle(color: Theme.of(context).colorScheme.primary),);
                    }
                    final comments = commentSnapshot.data!;
                    return 
                      Column(
                        children: comments.map((comment) {
                          return SingleChildScrollView(
                            child: Expanded(
                              child: PostWidget(
                                post: comment,
                                id: id,
                                onOptionTap: () => _showOptions(context, comment.postId!),
                                onPostTap: () => _navigateToPostDetail(comment, widget.user),
                                onImageTap: () => _handleImageTap(context, comment.postImageUrl!),
                                onLikeTap: _handleLikeTap,
                                onCommentTap: () => _handleCommentTap(comment, widget.user),
                                onShareTap: _handleShareTap,
                                onBookmarkTap: _handleBookmarkTap,
                              ),
                            )
                          ); 
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            )
          );
        },
      )
    );
  }
}