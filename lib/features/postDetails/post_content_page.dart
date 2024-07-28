import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostContentWidget extends StatefulWidget {
  final String postContent;
  final double screenWidth;
  final double screenHeight;

  PostContentWidget({
    required this.postContent,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  _PostContentWidgetState createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.screenHeight * 0.015), // 1.5% of screen height
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: isExpanded
                  ? widget.postContent
                  : widget.postContent.length > 100 // Đoạn giới hạn số ký tự ban đầu
                      ? '${widget.postContent.substring(0, 100)}...'
                      : widget.postContent,
              style: TextStyle(
                fontSize: widget.screenWidth * 0.04, // 4% of screen width
              ),
              children: [
                if (widget.postContent.length > 100) // Đoạn kiểm tra có cần hiển thị "Xem thêm" không
                  TextSpan(
                    text: isExpanded ? ' Thu gọn' : ' Xem thêm',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.screenWidth * 0.04, // 4% of screen width
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
