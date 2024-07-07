import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'info_provider.dart';
import 'dart:convert';
import 'dart:typed_data';

class WriteScreen extends StatefulWidget {
  final DateTime date;
  final IconData? icon;
  final Widget? customIcon;
  final List<Uint8List>? initialImages;
  final String? initialComment;

  WriteScreen({
    required this.date,
    this.icon,
    this.customIcon,
    this.initialImages,
    this.initialComment,
  });

  final myip = '192.168.0.20';

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late TextEditingController _commentController;
  late List<Uint8List> _images;

  // 이미지 픽커 중복 실행 방지
  bool _isImagePickerActive = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.initialComment);
    _images = widget.initialImages ?? [];
  }

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
          for (var image in images) {
            File imgFile = File(image.path);
            _images.add(imgFile.readAsBytesSync());
          }
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

  String _getIconName() {
    if (widget.icon == Icons.code) {
      return 'A';
    } else if (widget.icon == Icons.book) {
      return 'B';
    } else if (widget.icon == Icons.fitness_center) {
      return 'C';
    } else if (widget.icon == Icons.music_note) {
      return 'D';
    } else {
      return 'ETC';
    }
  }

  Future<void> _uploadData() async {
    var user = Provider.of<UserModel>(context, listen: false);

    var url = Uri.parse('http://${widget.myip}:8080/upload');

    // 아이콘 이름 결정
    String iconName = _getIconName();

    // 이미지를 Base64 문자열로 변환
    List<String> base64Images = _images.map((image) => base64Encode(image)).toList();
    final parsedDate = DateTime.parse(widget.date.toIso8601String());
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': user.id,
        'date': '${parsedDate.year}${parsedDate.month.toString().padLeft(2, '0')}${parsedDate.day.toString().padLeft(2, '0')}',
        'icon': iconName,
        'images': base64Images,
        'comment': _commentController.text
      }),
    );

    if (response.statusCode == 200) {
      print('Uploaded!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 성공${user.id}')),
      );
      Navigator.pop(context, {'images': _images, 'comment': _commentController.text});
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
                    Navigator.pop(context, {'images': _images, 'comment': _commentController.text});
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
                              child: Image.memory(
                                image,
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
