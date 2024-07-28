import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/comment/comment.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/home/widgets/like_provider.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/post_liker_model.dart';
import 'package:media_mobile/features/postDetails/post_content_page.dart';
import 'package:media_mobile/features/resume/data_sources/resume_data_sources.dart';
import 'package:media_mobile/features/resume/profile_user.dart';
import 'package:media_mobile/features/resume/resume_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';


class PostWidget extends StatefulWidget {
  final FullPostModel post;
  final VoidCallback onPostTap;
  final VoidCallback onImageTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onOptionTap;
  final String id;
  const PostWidget({super.key, required this.post, required this.onPostTap, required this.onImageTap, required this.onLikeTap, required this.onCommentTap, required this.onShareTap, required this.onBookmarkTap, required this.onOptionTap, required this.id});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool _isLiked;
  String liked = '0';
  UserModel user = UserModel.userEmpty();
  late Future<bool> getLiker;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

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

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    setState(() {
      getLiker = _getLikers();
    });
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
  

  Future<bool> _getLikers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLiked = await PostDataSource().getLiker(widget.id, widget.post.postId!,prefs.getString('token').toString());
    return isLiked;
  }

  void _toggleLike() async {
    setState(() {
      _isLiked = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    liked = await PostDataSource().likePost(widget.post.postId!, widget.id, prefs.getString('token').toString());
    setState(() {
      widget.post.postTotalLikes = liked;
    });
  }

  void _toggleDisLike() async {
    setState(() {
      _isLiked = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    liked = await PostDataSource().disLikePost(widget.post.postId!, widget.id, prefs.getString('token').toString());
    setState(() {
      widget.post.postTotalLikes = liked;
    });
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

  Future<UserModel> getProfileUser(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await ResumeDataSource().getProfileUser(userId, prefs.getString('token').toString());
    var currentUser = await AuthDataSources().currentUser(prefs.getString('token').toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileUser(user: user, currentUser: currentUser))
    );
    return user;
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    

    // Định dạng ngày tháng theo yêu cầu
    DateTime utcnow = DateTime.parse(widget.post.createdAt!);
    String formattedDate = _formatDate(utcnow);

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1
            ),
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => {},
              child: Padding(
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
                                    height: screenWidth * 0.11, // 11% of screen width
                                  ),
                                ),
                              ) else Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
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

                    if (widget.id == widget.post.userId) GestureDetector(
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
            ),
            if(widget.post.replierName != null)
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
                      widget.post.replierName!,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04, // 4% of screen width
                      ),
                    ),
                  ),
                ],
              )
              else Container(),
            if (widget.post.postContent != "") 
              PostContentWidget(
                postContent: widget.post.postContent!,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )
            else 
              Container(),

            if (widget.post.postImageUrl != "") 
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
            else if (widget.post.postVideoUrl != '' && _isVideoInitialized)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.95,
                    maxHeight: screenHeight * 0.95
                  ),
                  child: GestureDetector(
                  onTap: _togglePlayPause,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
                          child: Container(
                            width: double.infinity,
                            height: screenHeight * 0.80, // 28% of screen height
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                        if (!_videoController!.value.isPlaying)
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: screenWidth * 0.15, 
                          ),
                
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: VideoProgressIndicator(
                            _videoController!,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: Theme.of(context).colorScheme.primary,
                              backgroundColor: Colors.black38,
                              bufferedColor: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (widget.post.postVideoUrl != '' && !_isVideoInitialized)
            Container(),
            GestureDetector(
              onTap: () => {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      if(widget.post.postTotalComments != '0')
                        Text(
                          widget.post.postTotalComments!,
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
                      if(widget.post.postTotalShares != '0')
                        Text(
                          widget.post.postTotalShares!,
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
                      if(widget.post.postTotalMarks != '0')
                        Text(
                          widget.post.postTotalMarks!,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035, // 3.5% of screen width
                          ),
                        )
                      else Container(),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}