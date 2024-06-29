
import 'package:flutter/material.dart';
import 'package:media_mobile/features/home/widgets/postwidget.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({super.key, required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: false,
                floating: true,
                snap: true,
                backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                leading: GestureDetector(
                  onTap: () => {
                    widget.scaffoldKey.currentState?.openDrawer()
                  },
                  child: const Icon(Icons.account_circle, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
                ),
                title: Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                  width: 24,
                  height: 24,
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: () => {},
                    child: const Icon(Icons.settings, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
                  ),
                  SizedBox(width: 10,)
                ],
                centerTitle: true,
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color.fromRGBO(119, 82, 254, 1),
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  tabs: [
                    Tab(
                      child: Text(
                        'Bài đăng',
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Đang theo dõi',
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
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
                    userName: "Trần trọng lực",
                    createdAt: "13Thang6,2023",
                    postContent: "Kem nào mà chả là kem 🤡",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449075311_858182246346880_2844809673380097241_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=127cfc&_nc_ohc=J-F4cSwochUQ7kNvgGJHKRl&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYC2g2mnCGmhkcXREVCVrc96QR1ocTLnR-og3sh-VxLfZQ&oe=66830373',
                  ),
                  PostWidget(
                    userName: "BongDa24h",
                    createdAt: "12Thang6,2003",
                    postContent: "Rất nhiều người đã tắt máy sau khoảnh khắc này...",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449109017_876930851129592_3505890860484888784_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=127cfc&_nc_ohc=knoC0KOZyrsQ7kNvgGvo2Of&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYCRPqFApjMVu_s5112u-jjY263INCZ8CNfK5fMQdpB2Lg&oe=6682F537',
                  ),
                  PostWidget(
                    userName: "Anime - My Heart",
                    createdAt: "12Thang6,2003",
                    postContent: "Zen thật sự rất thương ông của mình 😢",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449064039_886112986879405_994842464257917050_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=127cfc&_nc_ohc=al9CPt_64XIQ7kNvgFXE7Pj&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYAbQlwsoa6_KQ6gDXUewtKGhVmFakSGY-m55d68nxV_MQ&oe=66830C0B',
                  ),
                  PostWidget(
                    userName: "BongDa21h",
                    createdAt: "12Thang6,2003",
                    postContent: "Liều ăn nhiều. Thành quả của ông cháu may mắn hôm qua 🤳",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449034864_874335811389096_5112525695222335557_n.jpg?stp=dst-jpg_p526x296&_nc_cat=102&ccb=1-7&_nc_sid=833d8c&_nc_ohc=9D-jzjECJ_0Q7kNvgENMGjw&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYBphcdM9r2dXezvH4i050GxnowqAhzyYfohXgVFJYe7Pw&oe=66830424',
                  ),
                  // Thêm các PostWidget khác nếu cần
                ],
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  PostWidget(
                    userName: "Anime - My Heart",
                    createdAt: "12Thang6,2003",
                    postContent: "Zen thật sự rất thương ông của mình 😢",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449064039_886112986879405_994842464257917050_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=127cfc&_nc_ohc=al9CPt_64XIQ7kNvgFXE7Pj&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYAbQlwsoa6_KQ6gDXUewtKGhVmFakSGY-m55d68nxV_MQ&oe=66830C0B',
                  ),
                  PostWidget(
                    userName: "BongDa21h",
                    createdAt: "12Thang6,2003",
                    postContent: "Liều ăn nhiều. Thành quả của ông cháu may mắn hôm qua 🤳",
                    totalLikes: 5,
                    totalComments: 20,
                    totalShares: 20,
                    totalMarks: 20, 
                    imageContent: 'https://scontent.fsgn2-11.fna.fbcdn.net/v/t39.30808-6/449034864_874335811389096_5112525695222335557_n.jpg?stp=dst-jpg_p526x296&_nc_cat=102&ccb=1-7&_nc_sid=833d8c&_nc_ohc=9D-jzjECJ_0Q7kNvgENMGjw&_nc_ht=scontent.fsgn2-11.fna&oh=00_AYBphcdM9r2dXezvH4i050GxnowqAhzyYfohXgVFJYe7Pw&oe=66830424',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
