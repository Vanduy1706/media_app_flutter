import 'package:flutter/material.dart';

class EditResume extends StatefulWidget {
  const EditResume({super.key});

  @override
  State<EditResume> createState() => _EditResumeState();
}

class _EditResumeState extends State<EditResume> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(38, 37, 43, 1),),
          onPressed: () => {
            Navigator.pop(context, true)
          },
        ),
        title: Text('Chỉnh sửa hồ sơ', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 20),),
        actions: [
          ElevatedButton(onPressed: () => {

          }, 
          child: Text('Lưu', style: TextStyle(color: Color.fromRGBO(244, 244, 244, 1)),),
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
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                  ),
                  Positioned(
                    child: Image.network(
                      'https://i.pinimg.com/564x/fa/64/60/fa646054678f88f90d036acec1803eee.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 150,
                      color: Colors.black26,
                    )
                  ),
                  Positioned(
                    top: 60,
                    child: Icon(Icons.camera_alt, color: Color.fromRGBO(244, 244, 244, 1), size: 36,),
                  )
                ],
              ),
              Stack(
                alignment: Alignment.topLeft,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 64,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/564x/f2/a4/b0/f2a4b0c2113874f7e8a46965c8e6ee6e.jpg'), // thay bằng đường dẫn ảnh đại diện của bạn
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 40,
                    )
                  ),
                  Positioned(
                    bottom: 42,
                    left: 32,
                    child: Icon(Icons.camera_alt, color: Color.fromRGBO(244, 244, 244, 1), size: 36,),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Họ và tên', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 16),),
                          TextField(
                            // controller: _nameUserController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color.fromRGBO(119, 82, 254, 1)),
                              hintText: 'Nhập tên'
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Giới thiệu bản thân', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 16),),
                          TextField(
                            // controller: _nameUserController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color.fromRGBO(119, 82, 254, 1)),
                              hintText: 'Nhập giới thiệu'
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Địa chỉ', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 16),),
                          TextField(
                            // controller: _nameUserController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color.fromRGBO(119, 82, 254, 1)),
                              hintText: 'Nhập địa chỉ'
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Công việc', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontWeight: FontWeight.bold, fontSize: 16),),
                          TextField(
                            // controller: _nameUserController,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color.fromRGBO(119, 82, 254, 1)),
                              hintText: 'Nhập công việc'
                            ),
                          ),
                        ],
                      ),
                    ),
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