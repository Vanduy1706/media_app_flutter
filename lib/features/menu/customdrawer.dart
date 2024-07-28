import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_mobile/config/theme.dart';
import 'package:media_mobile/core/shared_preferences/shared_pref.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/resume/resume_page.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel user;
  const CustomDrawer({super.key, required this.scaffoldKey, required this.user});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.user.personalImage != null ? 
                    CachedNetworkImageProvider(
                      widget.user.personalImage!,
                      cacheManager: CacheManager(
                        Config(
                          'customCacheKey',
                          stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                          maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                        ),
                      ),
                    ) : CachedNetworkImageProvider(
                      'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                      cacheManager: CacheManager(
                        Config(
                          'customCacheKey',
                          stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                          maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.user.userName!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '20 Đang theo dõi',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    '2 Người theo dõi',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
              UserModel user = UserModel.userEmpty();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResumePage()),
              );
              widget.scaffoldKey.currentState?.closeDrawer();
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
              value: Provider.of<ThemeNotifier>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () => logOut(context),
          ),
        ],
      ),
    );
  }
}
