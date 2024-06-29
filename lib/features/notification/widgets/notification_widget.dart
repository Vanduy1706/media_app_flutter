import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationWidget extends StatelessWidget {
  final String imageFollow;
  final String nameFollowUser;

  const NotificationWidget({super.key, required this.imageFollow, required this.nameFollowUser});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipOval(
                    child: Image.network(
                      imageFollow,
                      fit: BoxFit.cover,
                      width: screenWidth * 0.15, // 11% of screen width
                      height: screenWidth * 0.15,
                    ),  
                  )
                ),
                Text(nameFollowUser, style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 16),),
                SizedBox(width: 4,),
                Text('đã thích bài viết của bạn', style: TextStyle(color: Color.fromRGBO(92, 91, 96, 1), fontWeight: FontWeight.w400, fontSize: 16),)
              ],
            ),
            SvgPicture.asset(
              "assets/icons/arrow-right.svg",
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Color.fromRGBO(38, 37, 43, 1),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}