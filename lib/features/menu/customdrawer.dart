import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_mobile/features/resume/resume_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Color.fromRGBO(244, 244, 244, 1),
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/Toka.jpg'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Võ Văn Duy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(38, 37, 43, 1),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '20 Đang theo dõi',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '2 Người theo dõi',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Hồ sơ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResumePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Dấu trang'),
            onTap: () {
              // Add your onTap code here!
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/Group.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Color.fromRGBO(119, 82, 254, 1), 
                BlendMode.srcIn,
              ), 
            ),
            title: Text('Premium'),
            onTap: () {
              // Add your onTap code here!
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Chế độ sáng/tối'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              // Add your onTap code here!
            },
          ),
        ],
      ),
    );
  }
}
