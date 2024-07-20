import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/follow/followpage.dart';
import 'package:media_mobile/features/home/home_page.dart';
import 'package:media_mobile/features/menu/customdrawer.dart';
import 'package:media_mobile/features/notification/notificationpage.dart';
import 'package:media_mobile/features/post/post_form.dart';
import 'package:media_mobile/features/search/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isFabVisible = true;
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserModel user = UserModel.userEmpty();

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    super.initState();
    _getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    setState(() {
      user = UserModel.fromJson(jsonDecode(strUser));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!isFabVisible) {
              setState(() {
                isFabVisible = true;
              });
              _controller.reverse();
            }
          } else if (notification.direction == ScrollDirection.reverse) {
            if (isFabVisible) {
              setState(() {
                isFabVisible = false;
              });
              _controller.forward();
            }
          }
          return true;
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomePage(scaffoldKey: _scaffoldKey, user: user),
            FriendsPage(scaffoldKey: _scaffoldKey),
            NotificationsPage(scaffoldKey: _scaffoldKey,),
            SearchPage(scaffoldKey: _scaffoldKey,),
          ],
        ),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey, user: user),
      bottomNavigationBar: SizeTransition(
        sizeFactor: _offsetAnimation,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/majesticons_home.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 0 ? Color.fromRGBO(119, 82, 254, 1) : Color.fromRGBO(38, 37, 43, 1),
                  BlendMode.srcIn,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/bi_people-fill.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 1 ? Color.fromRGBO(119, 82, 254, 1) : Color.fromRGBO(38, 37, 43, 1),
                  BlendMode.srcIn,
                ),
              ),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/tabler_bell-filled.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 2 ? Color.fromRGBO(119, 82, 254, 1) : Color.fromRGBO(38, 37, 43, 1),
                  BlendMode.srcIn,
                ),
              ),
              label: 'Notify',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/iconamoon_search-fill.svg",
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 3 ? Color.fromRGBO(119, 82, 254, 1) : Color.fromRGBO(38, 37, 43, 1),
                  BlendMode.srcIn,
                ),
              ),
              label: 'Search',
            )
          ],
          backgroundColor: Color.fromRGBO(244, 244, 244, 1),
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(119, 82, 254, 1),
          unselectedItemColor: Color.fromRGBO(38, 37, 43, 1),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostForm(user: user,)),
                )
              },
              backgroundColor: Color.fromRGBO(119, 82, 254, 1),
              child: Icon(
                Icons.add,
                color: Color.fromRGBO(244, 244, 244, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
