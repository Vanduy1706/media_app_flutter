import 'package:flutter/material.dart';
import 'package:media_mobile/features/comment/widget/comment_widget.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({super.key});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Comments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
              ],
            ),
          ),
        ],
      ),
    );
  }
}