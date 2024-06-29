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
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        leading: GestureDetector(
          onTap: () => {
            widget.scaffoldKey.currentState?.openDrawer()
          },
          child: const Icon(Icons.account_circle, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
        ),
        title: Text('Đã theo dõi', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold),),
        actions: <Widget>[
          GestureDetector(
            onTap: () => {},
            child: const Icon(Icons.settings, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
          ),
          SizedBox(width: 10,)
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