import 'package:flutter/material.dart';
import 'package:media_mobile/core/shared_preferences/shared_pref.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/register/register_page.dart';
import 'package:media_mobile/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _accountPasswordController = TextEditingController();
  bool passwordObscured = true;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != "" || prefs.getString('user').toString() != "") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }
  
  @override
  void dispose() {
    _accountNameController.dispose();
    _accountPasswordController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  void _updateLoadingDialog(BuildContext context, IconData icon, Color color, String successMessage, String errorMessage) {
    Navigator.pop(context); // Close the current dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 20),
              Text(icon == Icons.check ? successMessage : errorMessage),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => {},
              child: Text('Hủy'),
            ),
          ],
        );
      },
    ).then((_) {
      if (icon == Icons.check) {
      } else {
        
      }
    });
  }

  Future<void> _login() async {
    if(_formKey.currentState?.validate() == true) {
      try {
        _showLoadingDialog(context, 'Đang đăng nhập...');
        String accountName = _accountNameController.text;
        String accountPassword = _accountPasswordController.text;
        final result = await AuthDataSources().login(accountName, accountPassword);

        var user = await AuthDataSources().currentUser(result.token!);

        await saveUser(user);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen())
        );
      } catch (e) {
        _updateLoadingDialog(context, Icons.close, Colors.red, 'Đăng nhập thành công!', 'Đăng nhập thất bại!');
      }
     
    }
  }

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
                child: Form(
                  key: _formKey,
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
                              TextFormField(
                                controller: _accountNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Nhập tài khoản",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập tài khoản';
                                  }
                                  return null;
                                },
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
                              TextFormField(
                                controller: _accountPasswordController,
                                obscureText: passwordObscured,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    padding: EdgeInsetsDirectional.only(end: 1),
                                    icon: Icon(passwordObscured ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        passwordObscured = !passwordObscured;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: "Nhập mật khẩu",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            onPressed: () => _login(),
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
