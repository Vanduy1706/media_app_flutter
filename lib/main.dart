import 'package:flutter/material.dart';
import 'package:media_mobile/config/dark_theme.dart';
import 'package:media_mobile/config/light_theme.dart';
import 'package:media_mobile/config/theme.dart';
import 'package:media_mobile/features/home/widgets/like_provider.dart';
import 'package:media_mobile/loadingscreen.dart';
import 'package:provider/provider.dart';


void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => LikeNotifier(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme:darkTheme,
          themeMode: themeNotifier.currentTheme,
          home: LoadingScreen()
        );
      },
    );
  }
}


