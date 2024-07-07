import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'info_provider.dart'; // Provider 클래스 정의 파일

class WriteScreen extends StatefulWidget {
  final DateTime date;
  final IconData? icon;
  final Widget? customIcon;

  WriteScreen({
    required this.date,
    this.icon,
    this.customIcon,
  });

  final myip = '192.168.0.20';

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<XFile> _images = [];

  // 이미지 픽커 중복 실행 방지
  bool _isImagePickerActive = false;

  Future<void> _pickImages() async {
    if (_isImagePickerActive) return;

    setState(() {
      _isImagePickerActive = true;
    });

    try {
      final ImagePicker _picker = ImagePicker();
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null) {
        setState(() {
          _images.addAll(images);
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    } finally {
      setState(() {
        _isImagePickerActive = false;
      });
    }
  }

  Future<void> _uploadData() async {
    var user = Provider.of<UserModel>(context, listen: false);

    var uri = Uri.parse('http://${widget.myip}:8080/upload');
    var request = http.MultipartRequest('POST', uri)
      ..fields['text'] = _commentController.text
      ..fields['date'] = widget.date.toIso8601String()
      ..fields['userName'] = user.id;

    for (var image in _images) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        filename: File(image.path).uri.pathSegments.last,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 성공${user.id}')),
      );
    } else {
      print('Failed to upload.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 실패${user.id}')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
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
                          SizedBox(width: 10),
                          ..._images.map((image) {
                            int index = _images.indexOf(image);
                            return GestureDetector(
                              onLongPress: () => _removeImage(index),
                              child: Image.file(
                                File(image.path),
                                width: 50,
                                height: 50,
                              ),
                            );
                          }).toList(),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.add, size: 30),
                            onPressed: _pickImages,
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
                        height: screenHeight * 0.5,
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
          title: Text('코멘트를 입력해주세요'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: '코멘트 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, _commentController.text),
              child: Text('입력'),
            ),
          ],
        );
      },
    );
  }
}
