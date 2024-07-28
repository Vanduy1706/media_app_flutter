import 'package:flutter/material.dart';

class FollowWidget extends StatelessWidget {
  final String imageFollow;
  final String nameFollowUser;

  const FollowWidget({super.key, required this.imageFollow, required this.nameFollowUser});

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
                Text(nameFollowUser, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500, fontSize: 16),)
              ],
            ),
            ElevatedButton(
              onPressed: () => {

              }, 
              child: Text(
                'Hủy theo dõi',
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
            )
          ],
        ),
      ),
    );
  }
}