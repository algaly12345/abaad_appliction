import 'dart:convert';
import 'dart:io';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ViewImageUploadScreen extends StatefulWidget {
  Estate estate;
  ViewImageUploadScreen(@required this.estate);
  @override
  _ViewImageUploadScreenState createState() => _ViewImageUploadScreenState();
}

class _ViewImageUploadScreenState extends State<ViewImageUploadScreen> {
  List<XFile> _imageFiles = [];
  List<String> _existingImageUrls = [];

  Future<void> _fetchExistingImages(int id) async {
    final response = await http.get(Uri.parse('https://abaad.iaspl.net/api/v1/estate/etch-existing-images/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingImageUrls = List<String>.from(data['image_data']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("--------------------------${widget.estate.id}");
    _fetchExistingImages(widget.estate.id);
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _imageFiles = selectedImages;
    });
  }

  Future<void> _uploadImages(int id) async {
    if (_imageFiles == null || _imageFiles.isEmpty) return;

    final ProgressDialog pr = ProgressDialog(context);
    pr.style(message: 'Uploading Images...');

    await pr.show();

    try {
      List<http.MultipartFile> imageFiles = [];
      for (var imageFile in _imageFiles) {
        List<int> imageBytes = await imageFile.readAsBytes();
        imageFiles.add(http.MultipartFile.fromBytes('images[]', imageBytes, filename: imageFile.name));
      }

      final Uri uploadUri = Uri.parse('https://abaad.iaspl.net/api/v1/estate/upload-images/$id');
      var request = http.MultipartRequest('POST', uploadUri);
      request.files.addAll(imageFiles);

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        _imageFiles.clear();
       Get.find<UserController>().getEstateByUser(1, false,widget.estate.userId);
        _fetchExistingImages(widget.estate.id);
      } else {
        print('Image upload failed');
      }
    } catch (e) {
      // Handle error
    } finally {
      pr.hide();
    }
  }

  Future<void> _deleteImage(String imageUrl, int id) async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(message: 'Deleting Image...');

    await pr.show();

    try {
      final response = await http.delete(Uri.parse('https://abaad.iaspl.net/api/v1/estate/delete-image/$id/$imageUrl'));

      if (response.statusCode == 200) {
        setState(() {
          _existingImageUrls.remove(imageUrl);
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      pr.hide();
    }
  }



  Widget _buildImageTile(String imageUrl, int id) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              '${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/' + Uri.encodeComponent(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
           Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child:ColoredBox(
              color: Color.fromARGB(155, 0, 0, 0),
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.delete,color: Colors.white,),
                  onPressed: () => _deleteImage(imageUrl, id),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: 'pictures_property'.tr),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _pickImages
                    , child:  Text('browse_and_add_photos'.tr))),
          ),
          Container(
            height: 130,

            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _imageFiles?.length ?? 0,
              itemBuilder: (context, index) {
                final imageFile = _imageFiles[index];
                return Image.file(File(imageFile.path));
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(4.0),
            width: double.infinity,
            color: Colors.transparent,
            child: OutlinedButton.icon(
                onPressed:()=>_uploadImages(widget.estate.id),
                icon:Icon(Icons.drive_folder_upload,color:Theme.of(context).primaryColor ),
                label:  Text("upload_images".tr)),
          ),
          SizedBox(height: 10),
          _existingImageUrls != null && _existingImageUrls.isNotEmpty
              ? Expanded(
            child:GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _existingImageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = _existingImageUrls[index];
                return _buildImageTile(imageUrl, widget.estate.id); // Replace 123 with the actual id
              },
            ),
          )
              : Container(),

        ],
      ),
    );
  }
}


