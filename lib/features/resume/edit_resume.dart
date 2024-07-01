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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(38, 37, 43, 1),),
          onPressed: () => {

          },
        ),
        title: Text('Chỉnh sửa hồ sơ'),
        actions: [
          ElevatedButton(onPressed: () => {}, child: Text('Lưu'))
        ],
      ),
    );
  }
}