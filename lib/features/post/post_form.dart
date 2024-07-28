import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_mobile/features/authentication/models/user_model.dart';
import 'package:media_mobile/features/home/fullPost_model.dart';
import 'package:media_mobile/features/post/post_data_source.dart';
import 'package:media_mobile/features/post/post_model.dart';
import 'package:media_mobile/features/resume/data_sources/resume_data_sources.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class PostForm extends StatefulWidget {
  final UserModel user;
  const PostForm({super.key, required this.user});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final ImagePicker _picker = ImagePicker();
  String _videoFile = '';
  VideoPlayerController? _videoController;

  var formKey = GlobalKey<FormState>();
  final TextEditingController _inputPostController = TextEditingController();
  String postImage = '';

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  void _clearMedia() {
    setState(() {
      _videoFile = '';
      _videoController?.dispose();
      _videoController = null;
      postImage = '';
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
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
  Future<void> _showVideoPickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chọn video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Quay video'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideo(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Chọn video từ thư viện'), 
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideo(ImageSource.gallery);
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
          if(_videoFile != '') {
            _videoFile = '';
          }
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

  Future<void> _pickVideo(ImageSource source) async {
    var cameraStatus = await Permission.camera.request();
    var storageStatus = await Permission.storage.request();
    
    if (cameraStatus.isGranted && storageStatus.isGranted) {
      final XFile? video = await _picker.pickVideo(source: source);
      if (video != null) {
        setState(() {
          if(postImage != '') {
            postImage = '';
          }
          _videoFile = video.path;
          if(video.path.endsWith('.mp4') || video.path.endsWith('.avi') || video.path.endsWith('.mov')) {
            setState(() {
              _videoController = VideoPlayerController.file(File(video.path))
                ..initialize().then((_) {
                  setState(() {}); // Cập nhật trạng thái để hiển thị video
                  _videoController!.play(); // Phát video sau khi đã initialize
                });
            });
          } else {
            _videoController?.dispose();
            _videoController = null;
          }
        });
      }
    } else {
      // Xử lý khi quyền bị từ chối
      print('Quyền bị từ chối');
    }
  }

  Future<void> _saveData() async {
    _showLoadingDialog(context, 'Đang đăng trạng thái');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(postImage != '') {
      postImage = await ResumeDataSource().uploadFile(postImage, prefs.getString('token').toString());
    } 

    if(_videoFile != '') {
      _videoFile = await ResumeDataSource().uploadFile(_videoFile, prefs.getString('token').toString());
    }

    var postContent = _inputPostController.text;

    var result = await PostDataSource().createPost(
      PostModel(postContent: postContent, postImageUrl: postImage, postVideoUrl: _videoFile, userId: prefs.getString('id').toString()),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: GestureDetector(
          onTap: () => {
            Navigator.pop(context)
          },
          child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary, size: 24,),
        ),
        title: Text('Viết bài đăng', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _saveData, 
              child: Text('Đăng', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
                    child: CachedNetworkImage(
                      imageUrl: widget.user.personalImage!,
                      progressIndicatorBuilder: (_, url, download) {
                        if(download.progress != null) {
                          return const LinearProgressIndicator();
                        }

                        return Text('Đã tải xong');
                      },
                      cacheManager: CacheManager(
                        Config(
                          'customCacheKey',
                          stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                          maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                        ),
                      ),
                      fit: BoxFit.cover,
                      width: 42,
                      height: 42,
                    ),
                  )
                else ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: 'https://static.vecteezy.com/system/resources/previews/000/376/355/original/user-management-vector-icon.jpg',
                      progressIndicatorBuilder: (_, url, download) {
                        if(download.progress != null) {
                          return const LinearProgressIndicator();
                        }

                        return Text('Đã tải xong');
                      },
                      cacheManager: CacheManager(
                        Config(
                          'customCacheKey',
                          stalePeriod: const Duration(days: 7), // Thời gian cache là 7 ngày
                          maxNrOfCacheObjects: 100, // Số lượng đối tượng tối đa trong cache
                        ),
                      ),
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
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: null,
                        ),
                        SizedBox(height: 10),
                        if(postImage != '') 
                        Stack(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight: 400,
                              ),
                              child: Image.file(
                                File(postImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Color.fromRGBO(119, 82, 254, 1)),
                                onPressed: _clearMedia,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        )
                        else if (_videoFile != '')
                        Stack(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight: 400,
                              ),
                              child: _videoController != null
                                ? GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: AspectRatio(
                                      aspectRatio: _videoController!.value.aspectRatio,
                                      child: VideoPlayer(_videoController!),
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close, color:Color.fromRGBO(119, 82, 254, 1)),
                                onPressed: _clearMedia,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),

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
            color: Theme.of(context).colorScheme.background,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary, // Màu viền
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
                  icon: Icon(Icons.video_collection, color: Color.fromRGBO(119, 82, 254, 1),),
                  onPressed: () => _showVideoPickerDialog(),
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
