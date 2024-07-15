import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_mobile/features/comment/comment.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.userName,
    required this.createdAt,
    required this.postContent,
    required this.totalLikes,
    required this.totalComments,
    required this.totalShares,
    required this.totalMarks,
    required this.imageContent,
    required this.onPostTap,
    required this.onImageTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onBookmarkTap,
  });

  final String userName;
  final String createdAt;
  final String postContent;
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final int totalMarks;
  final String imageContent;
  final VoidCallback onPostTap;
  final VoidCallback onImageTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPostTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.025), // 2.5% of screen width
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(147, 146, 149, 1),
              width: 1,
            ),
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
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.025), // 2.5% of screen width
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/Toka.jpg",
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
                              userName,
                              style: TextStyle(
                                color: Color.fromRGBO(38, 37, 43, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04, // 4% of screen width
                              ),
                            ),
                          ),
                          Text(
                            createdAt,
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
                  GestureDetector(
                    onTap: () => {},
                    child: Icon(
                      Icons.more_horiz,
                      color: Color.fromRGBO(38, 37, 43, 1),
                      size: screenWidth * 0.06, // 6% of screen width
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
              child: Text(
                postContent,
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // 4% of screen width
                ),
              ),
            ),
            GestureDetector(
              onTap: onImageTap,
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.015), // 1.5% of screen height
                child: Image.network(
                  imageContent,
                  fit: BoxFit.contain,
                  width: screenWidth * 0.95, // 95% of screen width
                ),
              ),
            ),
            Row(
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
                    Text(
                      '$totalLikes',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // 3.5% of screen width
                      ),
                    ),
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
                    Text(
                      '$totalComments',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // 3.5% of screen width
                      ),
                    ),
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
                    Text(
                      '$totalShares',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // 3.5% of screen width
                      ),
                    ),
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
                    Text(
                      '$totalMarks',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // 3.5% of screen width
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
