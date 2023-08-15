import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    List<XFile> images = await ImagePicker().pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _uploadImages() {
    // Implement the code to upload images to the server using the http package
  }

  void _deleteImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Select Images'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.file(File(_selectedImages[index].path)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteImage(index),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Text('Upload Images'),
          ),
        ],
      ),
    );
  }
}

