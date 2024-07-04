import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WriteScreen extends StatefulWidget {
  final DateTime date;
  final IconData? icon;
  final Widget? customIcon;

  WriteScreen({required this.date, this.icon, this.customIcon});

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _commentController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  ('${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일'),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 197, 230),
                  borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (widget.icon != null)
                      Icon(widget.icon, size: 40)
                    else if (widget.customIcon != null)
                      widget.customIcon!,
                    if (_image != null) ...[
                      SizedBox(width: 10),
                      Image.file(
                        File(_image!.path),
                        width: 50,
                        height: 50,
                      ),
                    ],
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add, size: 30),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                final String? comment = await _showCommentDialog(context);
                if (comment != null && comment.isNotEmpty) {
                  setState(() {
                    _commentController.text = comment;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 231, 197, 230),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Container(
                  width: screenWidth * 0.95,
                  height: screenHeight * 0.6, // 화면 높이에 맞춤
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Divider(
                          thickness: 4,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      SizedBox(height: 5),
                      Text(
                        _commentController.text.isEmpty
                            ? ''
                            : _commentController.text,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCommentDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Enter your comment here'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, _commentController.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
