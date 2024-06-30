import 'package:flutter/material.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _inputPostController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        leading: GestureDetector(
          onTap: () => {},
          child: Icon(Icons.arrow_back, color: Color.fromRGBO(38, 37, 43, 1), size: 24,),
        ),
        title: Text('Viết bài đăng', style: TextStyle(color: Color.fromRGBO(38, 37, 43, 1), fontSize: 20, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () => {}, 
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
                ClipOval(
                  child: Image.network(
                    'https://i.pinimg.com/564x/c0/88/24/c088243cfd312dfb173926b7189f6d09.jpg',
                    fit: BoxFit.cover,
                    width: 42,
                    height: 42,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
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
                      Image.network(
                        'https://i.pinimg.com/564x/06/4c/54/064c54621a1fb7492a441a7db2f3606b.jpg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ],
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo, color: Color.fromRGBO(119, 82, 254, 1),),
                  onPressed: () {
                    // Handle image upload from gallery
                  },
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
