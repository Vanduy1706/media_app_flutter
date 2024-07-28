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

class UpdatePostForm extends StatefulWidget {
  final UserModel user;
  final String postId;
  const UpdatePostForm({super.key, required this.user, required this.postId});

  @override
  State<UpdatePostForm> createState() => _UpdatePostFormState();
}

class _UpdatePostFormState extends State<UpdatePostForm> {
  final ImagePicker _picker = ImagePicker();
  var formKey = GlobalKey<FormState>();
  final TextEditingController _inputPostController = TextEditingController();
  String postImage = '';
  String postImageUpdate = '';
  FullPostModel? post;
  String _videoFile = '';
  String videoUpdateFile = '';
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

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
      postImageUpdate = '';
      videoUpdateFile = '';
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    post = await PostDataSource().getPost(widget.postId, prefs.getString('token').toString());
    setState(() {
      _inputPostController.text = post?.postContent ?? '';
      postImageUpdate = post?.postImageUrl ?? '';
      videoUpdateFile = post?.postVideoUrl ?? '';
    });
    if(post != null) {
      if (post!.postVideoUrl!.isNotEmpty) {
        setState(() {
          // ignore: deprecated_member_use
          _videoController = VideoPlayerController.network(post!.postVideoUrl!)
            ..initialize().then((_) {
              setState(() {}); // Cập nhật trạng thái để hiển thị video
              _videoController!.play(); // Phát video sau khi đã initialize
            });
        });
      }
    }
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
        setState(() {
          if(_videoFile != '') {
            _videoFile = '';
            videoUpdateFile = '';
          }
          postImage = image.path;
        });
      }
    } else if (status.isDenied) {
      print('Camera permission denied');
    } else if (status.isPermanentlyDenied) {
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
            postImageUpdate = '';
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

    if (postImage != '') {
      postImage = await ResumeDataSource().uploadFile(postImage, prefs.getString('token').toString());
    } 

    if(_videoFile != '') {
      _videoFile = await ResumeDataSource().uploadFile(_videoFile, prefs.getString('token').toString());
    }

    var postContent = _inputPostController.text;

    if(postImage == '' && _videoFile != '') {
      postImageUpdate = '';
    }

    if(postImage != '' && _videoFile == '') {
      videoUpdateFile = '';
    }
    
    var result = await PostDataSource().updatePost(
      FullPostModel(
        postId: widget.postId,
        postContent: postContent,
        postImageUrl: postImage == '' ? postImageUpdate : postImage,
        postVideoUrl: _videoFile == '' ?  videoUpdateFile : _videoFile,
        postFileUrl: '',
        postTotalLikes: '0',
        postTotalComments: '0',
        postTotalShares: '0',
        postTotalMarks: '0',
        userId: prefs.getString('id').toString(),
        userName: '',
        imageUser: '',
        replyId: '',
        replierName: '',
        createdAt: '',
      ),
      prefs.getString('token').toString(),
    );


    if (result == true) {
      _updateLoadingDialog(context, Icons.check, Colors.green, 'Cập nhật thành công!', 'Cập nhật thất bại!');
    } else {
      _updateLoadingDialog(context, Icons.close, Colors.red, 'Cập nhật thành công!', 'Cập nhật thất bại!');
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
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary, size: 24,),
        ),
        title: Text('Chỉnh sửa bài đăng', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _saveData, 
              child: Text('Cập nhật', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
            if(post != null)
              if(post!.replierName != null)
                Row(
                  children: [
                    Text(
                      'Đang trả lời',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 16, // 4% of screen width
                      ),
                    ),
                    SizedBox(width: 4,),
                    Flexible(
                      child: Text(
                        post!.replierName!,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16 // 4% of screen width
                        ),
                      ),
                    ),
                  ],
              )
              else Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.user.personalImage != null || widget.user.personalImage != '')
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
                    key: formKey,
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
                        )
                        else
                         if(postImageUpdate != '')  
                         Stack(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight: 400,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: postImageUpdate,
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
                        else if (videoUpdateFile != '')
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
                color: Theme.of(context).colorScheme.secondary,
                width: 1.0,
              ),
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
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
                    // Handle more options
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
