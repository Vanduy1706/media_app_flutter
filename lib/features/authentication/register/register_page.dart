import 'package:flutter/material.dart';
import 'package:media_mobile/features/authentication/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    bool passwordObscured = true;
    bool confirmedPasswordObscured = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% of screen width as padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.01), // 3% of screen height as padding
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đăng ký",
                          style: TextStyle(
                            color: Color.fromRGBO(38, 37, 43, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05, // 5% of screen width as font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01), // 2% of screen height as space
                        Text(
                          "Nhập thông tin cá nhân của bạn",
                          style: TextStyle(
                            color: Color.fromRGBO(147, 146, 149, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035, // 3.5% of screen width as font size
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.01), // 1% of screen height as padding
                              child: Text(
                                "Họ và tên",
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
                                hintText: "Nhập họ và tên",
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
                                "Tài khoản",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 37, 43, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
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
                              obscureText: passwordObscured,
                              decoration: InputDecoration(
                                suffixIcon:IconButton(
                                  padding: EdgeInsetsDirectional.only(end: 1),
                                  icon: Icon(passwordObscured ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      passwordObscured = !passwordObscured;
                                    });
                                  },
                                ),
                    
                                border: OutlineInputBorder(),
                                hintText: "Nhập Mật khẩu",
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
                                "Xác nhận mật khẩu",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 37, 43, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ),
                            TextField(
                              obscureText: confirmedPasswordObscured,
                              decoration: InputDecoration(
                                suffixIcon:IconButton(
                                  padding: EdgeInsetsDirectional.only(end: 1),
                                  icon: Icon(confirmedPasswordObscured ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      confirmedPasswordObscured = !confirmedPasswordObscured;
                                    });
                                  },
                                ),
                    
                                border: OutlineInputBorder(),
                                hintText: "Nhập xác nhận mật khẩu",
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Đăng ký',
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
                padding: EdgeInsets.only(top: screenHeight * 0.03), // 3% of screen height as padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản?',
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Đăng nhập ở đây.',
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
