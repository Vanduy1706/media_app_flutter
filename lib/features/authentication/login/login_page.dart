import 'package:flutter/material.dart';
import 'package:media_mobile/features/authentication/register/register_page.dart';
import 'package:media_mobile/mainscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight - MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% of screen width as padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.03), // 3% of screen height as padding
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: Color.fromRGBO(38, 37, 43, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05, // 5% of screen width as font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02), // 2% of screen height as space
                        Text(
                          "Đăng nhập để tiếp tục sử dụng mạng xã hội",
                          style: TextStyle(
                            color: Color.fromRGBO(147, 146, 149, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035, // 3.5% of screen width as font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.01), // 1% of screen height as padding
                              child: Text(
                                "Tài khoản",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 37, 43, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045, // 4.5% of screen width as font size
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Nhập tài khoản",
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: Text(
                                "Mật khẩu",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 37, 43, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  padding: EdgeInsetsDirectional.only(end: 12),
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {},
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Nhập Mật khẩu",
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: Color.fromRGBO(244, 244, 244, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.04, // 4% of screen width as font size
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                            minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07), // 80% of screen width and 8% of screen height as button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.06), // 6% of screen height as padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không có tài khoản?',
                      style: TextStyle(
                        color: Color.fromRGBO(147, 146, 149, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035, // 3.5% of screen width as font size
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Đăng ký ở đây.',
                        style: TextStyle(
                          color: Color.fromRGBO(119, 82, 254, 1),
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
