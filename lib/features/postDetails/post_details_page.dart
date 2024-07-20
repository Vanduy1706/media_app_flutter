import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailPage extends StatefulWidget {
  final FullPostModel post;
  final VoidCallback onOptionTap;
  final VoidCallback onImageTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;
  final String userId;
  const PostDetailPage({super.key, required this.post, required this.userId, required this.onOptionTap, required this.onImageTap, required this.onLikeTap, required this.onCommentTap, required this.onShareTap, required this.onBookmarkTap});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<FullPostModel> _loadPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await PostDataSource().getPost(widget.post.postId!, prefs.getString('token').toString());
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
          onPressed: () => {},
        ),
        title: Text('Bài đăng'),
      ),
      body: FutureBuilder<FullPostModel>(
        future: _loadPost(),
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
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
              decoration: BoxDecoration(    
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(224, 224, 224, 1),
                    width: 1,
                  ),
                  top: BorderSide(
                    color: Color.fromRGBO(224, 224, 224, 1),
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
                        Row(
                          children: [
                            if(post.imageUser != null)
                              Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                                child: ClipOval(
                                  child: Image.network(
                                    post.imageUser!,
                                    fit: BoxFit.cover,
                                    width: screenWidth * 0.11, // 11% of screen width
                                    height: screenWidth * 0.11, // 11% of screen width
                                  ),
                                ),
                              ) else Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                                child: ClipOval(
                                  child: Image.network(
                                    'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
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
                                    post.userName!,
                                    style: TextStyle(
                                      color: Color.fromRGBO(38, 37, 43, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.04, // 4% of screen width
                                    ),
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Color.fromRGBO(147, 146, 149, 1),
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.035, // 3.5% of screen width
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.userId == post.userId) GestureDetector(
                          onTap: widget.onOptionTap,
                          child: Icon(
                            Icons.more_horiz,
                            color: Color.fromRGBO(38, 37, 43, 1),
                            size: screenWidth * 0.06, // 6% of screen width
                          ),
                        ) else Container(),
                      ],
                    ),
                  ),
                  if(post.postContent != "") 
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
                      child: Text(
                        post.postContent!,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // 4% of screen width
                        ),
                      ),
                    )
                  else 
                    Container(),
                  if (post.postImageUrl != "") 
                    GestureDetector(
                    onTap: widget.onImageTap,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
                      child: Image.network(
                        post.postImageUrl!,
                        fit: BoxFit.contain,
                        width: screenWidth * 0.95, // 95% of screen width
                      ),
                    ),
                  ) 
                    else Container(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(224, 224, 224, 1),
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
                          color: Color.fromRGBO(224, 224, 224, 1),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: widget.onLikeTap,
                            child: Icon(
                              Icons.favorite_border,
                              color: Color.fromRGBO(38, 37, 43, 1),
                              size: screenWidth * 0.06, // 6% of screen width
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01), // 1% of screen width
                          if(post.postTotalLikes != '0')
                            Text(
                              post.postTotalLikes!,
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
                            onTap: widget.onCommentTap,
                            child: SvgPicture.asset(
                              'assets/icons/chat-square-text.svg',
                              width: screenWidth * 0.06, // 6% of screen width
                              height: screenWidth * 0.06, // 6% of screen width
                              colorFilter: ColorFilter.mode(
                                Color.fromRGBO(38, 37, 43, 1),
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
                              color: Color.fromRGBO(38, 37, 43, 1),
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
                              color: Color.fromRGBO(38, 37, 43, 1),
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
            )
          );
        },
      )
    );
  }
}