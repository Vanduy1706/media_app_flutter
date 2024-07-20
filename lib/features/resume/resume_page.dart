import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';
import 'package:media_mobile/features/resume/edit_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserModel user = UserModel.userEmpty();
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = UserModel.fromJson(jsonDecode(strUser));

    // Chuyển đổi và định dạng ngày tháng
    DateTime utcnow = DateTime.parse(user.createdAt!);
    DateTime localTime = utcnow.toLocal();
    formattedDate = DateFormat('dd/MM/yyyy').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(244, 244, 244, 1)),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color.fromRGBO(244, 244, 244, 1)),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: getDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildUserProfile(context);
          }
        },
      ),
    );
  }

  Widget buildUserProfile(BuildContext context) {
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: user.backgroundImage != null ? BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(user.backgroundImage!),
                  fit: BoxFit.cover,
                ),
              ) : BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://th.bing.com/th/id/OIP.izuUPw06Klw7NffcjplZ4gHaEK?rs=1&pid=ImgDetMain')
                )
              ),
            ),
            Stack(
              alignment: Alignment.topLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 70,
                ),
                Positioned(
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditResume(user: user)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(color: Color.fromRGBO(244, 244, 244, 1)),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 30,
                  child: user.personalImage != null ?  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.personalImage!),
                  ) : CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if(user.decription != null)
                  Text(
                    user.decription!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                  else Container(),
                  SizedBox(height: 16),
                  if(user.address != null)
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text(user.address!),
                    ],
                  )
                  else Container(),
                  SizedBox(height: 8),
                  if(user.job != null)
                  Row(
                    children: [
                      Icon(Icons.school),
                      SizedBox(width: 8),
                      Text(user.job!),
                    ],
                  )
                  else Container(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),
                      Text('Đã tham gia vào ngày $formattedDate'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(
                    'Bài đăng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Lượt bình luận',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Bài viết',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Lượt thích',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Phương tiện',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
              labelColor: Color.fromRGBO(38, 37, 43, 1),
              indicatorColor: Color.fromRGBO(119, 82, 254, 1),
              indicatorPadding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Lượt bình luận')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Bài viết')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Lượt thích')),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Center(child: Text('Phương tiện')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPostDetail() {}

  void _handleLikeTap() {}

  void _handleCommentTap() {}

  void _handleShareTap() {}

  void _handleBookmarkTap() {}

  _handleImageTap(String imageUrl) {}
}
