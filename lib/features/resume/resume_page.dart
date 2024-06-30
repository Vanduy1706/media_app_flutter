import 'package:flutter/material.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart'; // Đảm bảo rằng đường dẫn này đúng

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Đảm bảo hình chữ nhật nằm dưới app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(244, 244, 244, 1)),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color.fromRGBO(244, 244, 244, 1)),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(244, 244, 244, 1), // Chỉnh màu nền cho toàn màn hình
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                clipBehavior: Clip.none, // Đảm bảo hình tròn không bị cắt
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/564x/fa/64/60/fa646054678f88f90d036acec1803eee.jpg'), // thay bằng đường dẫn ảnh nền của bạn
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 200,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(119, 82, 254, 1), // Màu nền của nút
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
                    top: 160, // điều chỉnh vị trí của hình tròn để nó đè lên hình chữ nhật
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/564x/f2/a4/b0/f2a4b0c2113874f7e8a46965c8e6ee6e.jpg'), // thay bằng đường dẫn ảnh đại diện của bạn
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Võ Văn Duy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tôi tên là Duy, sinh viên trường đại học HUFLIT',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.cake),
                        SizedBox(width: 8),
                        Text('Sinh ngày 17 tháng 6, 2003'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text('0789-831-843'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8),
                        Text('Thành phố Hồ Chí Minh, Vietnam'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.school),
                        SizedBox(width: 8),
                        Text('Sinh viên'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8),
                        Text('Đã tham gia tháng 2 năm 2022'),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Đặt TabBar ở đây
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Bài đăng'),
                      ],
                      labelColor: Colors.black,
                      indicatorColor: Color.fromRGBO(119, 82, 254, 1),
                    ),
                    SizedBox(
                      height: 400, // điều chỉnh chiều cao tùy ý
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              PostWidget(
                                userName: "Võ Văn Duy",
                                createdAt: "12Thang6,2025",
                                postContent: "Núi phú sĩ",
                                totalLikes: 5,
                                totalComments: 20,
                                totalShares: 20,
                                totalMarks: 20,
                                imageContent: 'https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg',
                              ),
                              PostWidget(
                                userName: "Võ Văn Duy",
                                createdAt: "12Thang6,2025",
                                postContent: "Núi phú sĩ",
                                totalLikes: 5,
                                totalComments: 20,
                                totalShares: 20,
                                totalMarks: 20,
                                imageContent: 'https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg',
                              ),
                              PostWidget(
                                userName: "Võ Văn Duy",
                                createdAt: "12Thang6,2025",
                                postContent: "Núi phú sĩ",
                                totalLikes: 5,
                                totalComments: 20,
                                totalShares: 20,
                                totalMarks: 20,
                                imageContent: 'https://www.tugo.com.vn/wp-content/uploads/nui-phu-si-ngon.jpg',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
