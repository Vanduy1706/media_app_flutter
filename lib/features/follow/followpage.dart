import 'package:flutter/material.dart';
import 'package:media_mobile/features/follow/widgets/follow_widget.dart';

class FriendsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const FriendsPage({super.key, required this.scaffoldKey});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: GestureDetector(
          onTap: () => {
            widget.scaffoldKey.currentState?.openDrawer()
          },
          child: Icon(Icons.account_circle, color: Theme.of(context).appBarTheme.iconTheme?.color, size: screenWidth * 0.06), // 6% of screen width
        ),
        title: Text(
          'Đã theo dõi',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05, // 5% of screen width
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => {},
            child: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary, size: screenWidth * 0.06), // 6% of screen width
          ),
          SizedBox(width: screenWidth * 0.025), // 2.5% of screen width
        ],
      ),
      body: ListView(
        children: [
          FollowWidget(
            imageFollow: 'https://khoinguonsangtao.vn/wp-content/uploads/2022/02/anh-dai-dien-fb-dep.jpg',
            nameFollowUser: 'Sang Đặng',
          ),
          FollowWidget(
            imageFollow: 'https://toigingiuvedep.vn/wp-content/uploads/2023/03/hinh-anh-avatar-dep-nu-ngau.jpg',
            nameFollowUser: 'Trạng Quỳnh',
          ),
          FollowWidget(
            imageFollow: 'https://leuxonghoi.net.vn/wp-content/uploads/2021/07/anh-dai-dien-4.jpg',
            nameFollowUser: 'Trần Thị Như Ý',
          ),
        ]
      ),
    );
  }
}
