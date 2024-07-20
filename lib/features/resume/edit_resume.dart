import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_mobile/core/shared_preferences/shared_pref.dart';
import 'package:media_mobile/features/authentication/data_sources/auth_data_sources.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/resume/data_sources/resume_data_sources.dart';
import 'package:media_mobile/features/resume/models/profile_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditResume extends StatefulWidget {
  final UserModel user;
  const EditResume({super.key, required this.user});

  @override
  State<EditResume> createState() => _EditResumeState();
}

class _EditResumeState extends State<EditResume> {
  final ImagePicker _picker = ImagePicker();
  String personalImage = '';
  String backgroundImage = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _jobController = new TextEditingController();
  String _personalImage = '';
  String _backgroundImage = '';

  @override
  initState() {
    super.initState();
    getCurrentUser();
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
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
          ],
        );
      },
    ).then((_) {
      if (icon == Icons.check) {
        Navigator.pop(context);
      }
    });
  }

  getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      var user = jsonDecode(prefs.getString('user').toString());
      setState(() {
        _userNameController.text = user["userName"] ?? '';
        _descriptionController.text = user["decription"] ?? '';
        _addressController.text = user["address"] ?? '';
        _jobController.text = user["job"] ?? '';
      });
    }
  }

  Future<void> _showImagePickerDialog(bool isPersonalImage) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn hình ảnh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Chụp ảnh'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, isPersonalImage);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery, isPersonalImage);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveData() async {
    _showLoadingDialog(context, 'Đang cập nhật...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (personalImage == '') {
      var user = jsonDecode(prefs.getString('user').toString());
      personalImage = user['personalImage'];
    } else {
      personalImage = await ResumeDataSource().uploadFile(personalImage, prefs.getString('token').toString());
    }

    if (backgroundImage == '') {
      var user = jsonDecode(prefs.getString('user').toString());
      backgroundImage = user['backgroundImage'];
    } else {
      backgroundImage = await ResumeDataSource().uploadFile(backgroundImage, prefs.getString('token').toString());
    }

    String userName = _userNameController.text;
    String description = _descriptionController.text;
    String address = _addressController.text;
    String job = _jobController.text;

    var result = await ResumeDataSource().changeProfile(
      ProfileModel(
        userName: userName,
        description: description,
        address: address,
        job: job,
        personalImage: personalImage,
        backgroundImage: backgroundImage,
      ),
      prefs.getString('id').toString(),
      prefs.getString('token').toString()
    );

    if (result == true) {
      var userUpdate = await AuthDataSources().currentUser(prefs.getString('token').toString());
      saveUser(userUpdate);
      _updateLoadingDialog(context, Icons.check, Colors.green, 'Cập nhật thành công', 'Cập nhật thất bại');
    } else {
      _updateLoadingDialog(context, Icons.close, Colors.red, 'Cập nhật thất bại', 'Cập nhật thất bại');
    }

    print('Personal Image: $personalImage');
    print('Background Image: $backgroundImage');
  }

  Future<void> _pickImage(ImageSource source, bool isPersonalImage) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Handle the selected image
        setState(() {
          if (isPersonalImage) {
            personalImage = image.path;
          } else {
            backgroundImage = image.path;
          }
        });
      }
    } else if (status.isDenied) {
      // The permission was denied. Show a message or handle the error.
      print('Camera permission denied');
    } else if (status.isPermanentlyDenied) {
      // The permission was permanently denied. Direct the user to the app settings.
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(38, 37, 43, 1)),
          onPressed: () => {Navigator.pop(context, true)},
        ),
        title: Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(
            color: Color.fromRGBO(38, 37, 43, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _saveData,
            child: Text(
              'Lưu',
              style: TextStyle(color: Color.fromRGBO(244, 244, 244, 1)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(119, 82, 254, 1),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5)
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showImagePickerDialog(false),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(height: 150),
                    if (backgroundImage != '')
                      Image.file(
                        File(backgroundImage),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      widget.user.backgroundImage != null ? Image.network(
                        widget.user.backgroundImage!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ) : Image.network(
                        'https://th.bing.com/th/id/OIP.izuUPw06Klw7NffcjplZ4gHaEK?rs=1&pid=ImgDetMain',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Container(
                      height: 150,
                      color: Colors.black26,
                    ),
                    Positioned(
                      top: 60,
                      child: Icon(
                        Icons.camera_alt,
                        color: Color.fromRGBO(244, 244, 244, 1),
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showImagePickerDialog(true),
                child: Stack(
                  alignment: Alignment.topLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Container(height: 64),
                    if (personalImage != '')
                      Positioned(
                        bottom: 20,
                        left: 10,
                        child: ClipOval(
                          child: Image.file(
                            File(personalImage),
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 20,
                        left: 10,
                        child: ClipOval(
                          child: widget.user.personalImage != null ? Image.network(
                            widget.user.personalImage!,
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                          ) : Image.network(
                            'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Color.fromRGBO(244, 244, 244, 1),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên người dùng',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 82, 254, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _userNameController,
                      style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1)),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(244, 244, 244, 1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'Tên người dùng',
                        hintStyle: TextStyle(color: Color.fromRGBO(38, 37, 43, 0.3)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mô tả',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 82, 254, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _descriptionController,
                      style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1)),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(244, 244, 244, 1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'Mô tả',
                        hintStyle: TextStyle(color: Color.fromRGBO(38, 37, 43, 0.3)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Địa chỉ',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 82, 254, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _addressController,
                      style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1)),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(244, 244, 244, 1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'Địa chỉ',
                        hintStyle: TextStyle(color: Color.fromRGBO(38, 37, 43, 0.3)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Công việc',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 82, 254, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _jobController,
                      style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1)),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(244, 244, 244, 1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: 'Công việc',
                        hintStyle: TextStyle(color: Color.fromRGBO(38, 37, 43, 0.3)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
