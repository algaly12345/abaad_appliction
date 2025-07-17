
import 'dart:convert';
import 'dart:io';

import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
class PlannedTab extends StatefulWidget {
  final int index;
  Estate estate;

  PlannedTab({required this.index,required this.estate});

  @override
  State<PlannedTab> createState() => _PlannedTabState();
}
class _PlannedTabState extends State<PlannedTab> {
  List<XFile> _plannedFiles = [];
  List<String> _existingPlannedUrls = [];
  int _currentIndex = 0;

  Future<void> _fetchExistingPlanned(int id) async {
    final response = await http.get(Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/etch-existing-planned/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _existingPlannedUrls = List<String>.from(data['image_data']);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("--------------------------${widget.estate.id}");
    _fetchExistingPlanned(widget.estate.id);
  }

  Future<void> _pickPlanned() async {
    final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    setState(() {
      _plannedFiles = selectedImages;
    });
  }

  Future<void> _uploadPlanned(int id) async {
    if (_plannedFiles == null || _plannedFiles.isEmpty) return;

    final ProgressDialog pr = ProgressDialog(context);
    pr.style(message: 'Uploading Images...');

    await pr.show();

    try {
      List<http.MultipartFile> imageFiles = [];
      for (var imageFile in _plannedFiles) {
        List<int> imageBytes = await imageFile.readAsBytes();
        imageFiles.add(http.MultipartFile.fromBytes('planned[]', imageBytes, filename: imageFile.name));
      }

      final Uri uploadUri = Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/upload-planned/$id');
      var request = http.MultipartRequest('POST', uploadUri);
      request.files.addAll(imageFiles);

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        _plannedFiles.clear();
        Get.find<UserController>().getEstateByUser(1, false,widget.estate.userId);
        _fetchExistingPlanned(widget.estate.id);
      } else {
        print('Image upload failed');
      }
    } catch (e) {
      // Handle error
    } finally {
      pr.hide();
    }
  }

  Future<void> _deletePlanned(String imageUrl, int id) async {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(message: 'Deleting Image...');

    await pr.show();

    try {
      final response = await http.delete(Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/delete-planned/$id/$imageUrl'));

      if (response.statusCode == 200) {
        setState(() {
          _existingPlannedUrls.remove(imageUrl);
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      pr.hide();
    }
  }


  Widget _buildPlannedTile(String imageUrl, int id) {

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
                  onPressed: () => _deletePlanned(imageUrl, id),
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
    return GestureDetector(
      onTap: () {
        print('Tab tapped: ${widget.index}');
      },
      child: Center(child:Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(4.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _pickPlanned,style: ElevatedButton.styleFrom(
                  primary:Theme.of(context).primaryColor),
                  child:  Text('browse_and_add_photos'.tr)),),
          ),
          Container(
            height: 130,

            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _plannedFiles?.length ?? 0,
              itemBuilder: (context, index) {
                final imageFile = _plannedFiles[index];
                return Image.file(File(imageFile.path));
              },
            ),
          ),

          Container(
            padding:  EdgeInsets.all(4.0),
            width: double.infinity,
            color: Colors.transparent,
            child: OutlinedButton.icon(
                onPressed:()=>_uploadPlanned(widget.estate.id),
                icon:Icon(Icons.drive_folder_upload,color:Theme.of(context).primaryColor ),
                label:  Text("upload_images".tr)),
          ),
          SizedBox(height: 10),
          _existingPlannedUrls != null && _existingPlannedUrls.isNotEmpty
              ? Expanded(
            child:GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _existingPlannedUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = _existingPlannedUrls[index];
                return _buildPlannedTile(imageUrl, widget.estate.id); // Replace 123 with the actual id
              },
            ),
          )
              : Container(),

        ],
      ),),
    );
  }
}