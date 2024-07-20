import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/comment/comment.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.onPostTap,
    required this.onImageTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onBookmarkTap, 
    required this.post, 
    required this.id, 
    required this.onOptionTap,
  });

  final FullPostModel post;
  final VoidCallback onPostTap;
  final VoidCallback onImageTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onOptionTap;
  final String id;

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

    // Định dạng ngày tháng theo yêu cầu
    DateTime utcnow = DateTime.parse(post.createdAt!);
    String formattedDate = _formatDate(utcnow);

    return GestureDetector(
      onTap: onPostTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(244, 244, 244, 1),
              width: 1
            ),
            bottom: BorderSide(
              color: Color.fromRGBO(244, 244, 244, 1),
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
                    if (id == post.userId) GestureDetector(
                      onTap: onOptionTap,
                      child: Icon(
                        Icons.more_horiz,
                        color: Color.fromRGBO(38, 37, 43, 1),
                        size: screenWidth * 0.06, // 6% of screen width
                      ),
                    ) else Container(),
                  ],
                ),
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
              onTap: onImageTap,
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
            GestureDetector(
              onTap: () => {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onLikeTap,
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
                        onTap: onCommentTap,
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
                        onTap: onShareTap,
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
                        onTap: onBookmarkTap,
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
            )
          ],
        ),
      ),
    );
  }
}
