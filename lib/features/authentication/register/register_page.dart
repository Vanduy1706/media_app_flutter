import 'package:flutter/material.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/login/login_page.dart';
import 'package:media_mobile/features/authentication/models/register_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = new TextEditingController();
  final _accountNameController = new TextEditingController();
  final _accountPasswordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();
  bool passwordObscured = true;
  bool confirmedPasswordObscured = true;

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

  Future<void> _register() async {
    if(_formKey.currentState?.validate() == true) {
      try {
        _showLoadingDialog(context, 'Thực hiện đăng ký...');
        var userName = _userNameController.text;
        var accountName = _accountNameController.text;
        var accountPassword = _accountPasswordController.text;
        var confirmPassword = _confirmPasswordController.text;

        var result = await AuthDataSources().register(RegisterModel(userName: userName, accountName: accountName, accountPassword: accountPassword, confirmPassword: confirmPassword));

        _updateLoadingDialog(context, Icons.check, Colors.green, 'Đăng ký thành công!', 'Đăng ký thất bại');
      } catch (e) {

        _updateLoadingDialog(context, Icons.close, Colors.red, 'Đăng ký thành công!', 'Đăng ký thất bại');
      }

    }
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
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        );
      },
    ).then((_) {
      if (icon == Icons.check) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage())
        );
      } else {
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
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
                        padding: EdgeInsets.only(bottom: screenHeight * 0.01), // 3% of screen height as padding
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đăng ký",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05, // 5% of screen width as font size
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01), // 2% of screen height as space
                          Text(
                            "Nhập thông tin cá nhân của bạn",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045, // 4.5% of screen width as font size
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _userNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Nhập họ và tên",
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Vui lòng nhập họ và tên';
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
                                  "Tài khoản",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _accountNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Nhập tài khoản",
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
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
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                              ),
                              TextFormField(
                                obscureText: passwordObscured,
                                controller: _accountPasswordController,
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
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
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
                                  "Xác nhận mật khẩu",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.045,
                                  ),
                                ),
                              ),
                              TextFormField(
                                obscureText: confirmedPasswordObscured,
                                controller: _confirmPasswordController,
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
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold),
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Vui lòng nhập xác nhận mật khẩu';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            onPressed: () => _register(),
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                color: Colors.white,
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
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.03), // 3% of screen height as padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.035, // 3.5% of screen width as font size
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
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
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              )
            ],
          ),
        ),
      
    );
  }
}
