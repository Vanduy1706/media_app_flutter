import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationWidget extends StatelessWidget {
  final String imageFollow;
  final String nameFollowUser;

  const NotificationWidget({super.key, required this.imageFollow, required this.nameFollowUser});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
                    width: screenWidth * 0.15, // 15% of screen width
                    height: screenWidth * 0.15,
                  ),  
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameFollowUser,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04, // 4% of screen width
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01), // 1% of screen width
                  Text(
                    'đã thích bài viết của bạn',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * 0.04, // 4% of screen width
                    ),
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset(
            "assets/icons/arrow-right.svg",
            width: screenWidth * 0.06, // 6% of screen width
            height: screenWidth * 0.06,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
