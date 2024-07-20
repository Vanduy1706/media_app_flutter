import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/post_model.dart';
import 'package:media_mobile/features/resume/data_sources/resume_data_sources.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostForm extends StatefulWidget {
  final UserModel user;
  const PostForm({super.key, required this.user});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final ImagePicker _picker = ImagePicker();
  var formKey = GlobalKey<FormState>();
  final TextEditingController _inputPostController = TextEditingController();
  String postImage = '';

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
              child: Text('Ok'),
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

  Future<void> _showImagePickerDialog() async {
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
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Handle the selected image
        setState(() {
          postImage = image.path;
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

  Future<void> _saveData() async {
    _showLoadingDialog(context, 'Đang đăng trạng thái');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(postImage != '') {
      postImage = await ResumeDataSource().uploadFile(postImage, prefs.getString('token').toString());
    } 

    var postContent = _inputPostController.text;

    var result = await PostDataSource().createPost(
      PostModel(postContent: postContent, postImageUrl: postImage, userId: prefs.getString('id').toString()),
      prefs.getString('token').toString()
    );

    if(result == true) {
      _updateLoadingDialog(context, Icons.check, Colors.green, 'Đăng thành công!', 'Đăng thất bại!');
    } else {
      _updateLoadingDialog(context, Icons.close, Colors.red, 'Đăng thành công!', 'Đăng thất bại!');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        leading: GestureDetector(
          onTap: () => {
            Navigator.pop(context)
          },
          child: Icon(Icons.arrow_back, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
        ),
        title: Text('Viết bài đăng', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _saveData, 
              child: Text('Đăng', style: TextStyle(color: Color.fromRGBO(244, 244, 244, 1), fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(119, 82, 254, 1),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5)
              ),
            ),
          ),  
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.user.personalImage != null)
                  ClipOval(
                    child: Image.network(
                      widget.user.personalImage!,
                      fit: BoxFit.cover,
                      width: 42,
                      height: 42,
                    ),
                  )
                else ClipOval(
                    child: Image.network(
                      'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                      fit: BoxFit.cover,
                      width: 42,
                      height: 42,
                    ),
                  ),
                SizedBox(width: 10),
                Expanded(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _inputPostController,
                          decoration: InputDecoration(
                            hintText: 'Nói lên cảm nghĩ của bạn.',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(92, 91, 96, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color.fromRGBO(38, 37, 43, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 10),
                        if(postImage != '') 
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 500.0, // Đặt giới hạn chiều cao tối đa
                              maxWidth: double.infinity, // Đặt giới hạn chiều rộng tối đa
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain, // Đảm bảo ảnh không bị cắt xén và duy trì tỷ lệ gốc
                              child: Image.file(
                                File(postImage),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1),
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(201, 200, 202, 1), // Màu viền
                width: 1.0,
              ),
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent, // Đặt màu nền trong suốt để chỉ thấy màu của Container
            elevation: 0, // Loại bỏ shadow
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo, color: Color.fromRGBO(119, 82, 254, 1),),
                  onPressed: () => _showImagePickerDialog(),
                ),
                IconButton(
                  icon: Icon(Icons.gif, color: Color.fromRGBO(119, 82, 254, 1)),
                  onPressed: () {
                    // Handle gif selection
                  },
                ),
                IconButton(
                  icon: Icon(Icons.poll, color: Color.fromRGBO(119, 82, 254, 1)),
                  onPressed: () {
                    // Handle gif selection
                  },
                ),
                IconButton(
                  icon: Icon(Icons.location_on, color: Color.fromRGBO(119, 82, 254, 1)),
                  onPressed: () {
                    // Handle gif selection
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Color.fromRGBO(119, 82, 254, 1)),
                  onPressed: () {
                    // Handle gif selection
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
