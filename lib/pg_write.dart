import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class WriteScreen extends StatefulWidget {
  final String id;
  final DateTime date;
  final IconData? icon;
  final Widget? customIcon;

  WriteScreen({
    required this.id,
    required this.date,
    this.icon,
    this.customIcon,
  });

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _commentController = TextEditingController();
  XFile? _image;
  bool _isImagePickerActive = false;

  Future<void> _pickImage() async {
    if (_isImagePickerActive) return;

    setState(() {
      _isImagePickerActive = true;
    });

    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isImagePickerActive = false;
      });
    }
  }

  Future<void> _uploadData() async {
    var uri = Uri.parse('http://192.168.55.225:8080/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['text'] = _commentController.text
      ..fields['date'] = widget.date.toIso8601String()
      ..fields['userName'] = widget.id; // 유저 이름 추가

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        filename: File(_image!.path).uri.pathSegments.last,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 성공${widget.id}')),
      );
    } else {
      print('Failed to upload.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 실패${widget.id}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.save, size: 30),
                        onPressed: _uploadData,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: screenWidth * 0.9,
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
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.5, // 화면 높이에 맞춤
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
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
