import 'package:flutter/material.dart';
import 'package:media_mobile/features/notification/widgets/notification_widget.dart';

class NotificationsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const NotificationsPage({super.key, required this.scaffoldKey});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        leading: GestureDetector(
          onTap: () => {
            widget.scaffoldKey.currentState?.openDrawer()
          },
          child: Icon(Icons.account_circle, color: Color.fromRGBO(38, 37, 43, 1), size: screenWidth * 0.06), // 6% of screen width
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(
            color: Color.fromRGBO(38, 37, 43, 1),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05, // 5% of screen width
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => {},
            child: Icon(Icons.settings, color: Color.fromRGBO(38, 37, 43, 1), size: screenWidth * 0.06), // 6% of screen width
          ),
          SizedBox(width: screenWidth * 0.025), // 2.5% of screen width
        ],
      ),
      body: ListView(
        children: [
          NotificationWidget(
            imageFollow: 'https://i.pinimg.com/564x/15/b2/49/15b249ab34dcde0ec37da0cf6e0a46ca.jpg',
            nameFollowUser: 'Draco MalFoy',
          ),
          NotificationWidget(
            imageFollow: 'https://i.pinimg.com/736x/86/db/20/86db2087d10f3947a462ea61bec49fb7.jpg',
            nameFollowUser: 'Homie Wack',
          ),
          NotificationWidget(
            imageFollow: 'https://i.pinimg.com/564x/55/f9/6a/55f96a3c81a433b93cd7c910977923e0.jpg',
            nameFollowUser: 'Elizabeth',
          ),
        ]
      ),
    );
  }
}
