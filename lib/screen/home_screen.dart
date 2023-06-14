import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../common/buttons.dart';
import '../widget/select_image_options_widget.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const id = "home_screen";

  @override
  State<HomeScreen> createState() => _SetHomeScreenState();
}

class _SetHomeScreenState extends State<HomeScreen> {
  File? _image;
  List<Filter> filters = presetFiltersList;

  String albumName = 'Media';
  String selectPhotoTitile = "Select photo";

  Future _pickImg(ImageSource imageSource) async {
    try {
      final img = await ImagePicker().pickImage(source: imageSource);
      if (img == null) return;
      File? image = File(img.path);
      image = await _cropImg(imgFile: image);
      setState(() {
        _image = image;
      });
      GallerySaver.saveImage(_image!.path, albumName: albumName);
      print("Picture saved!");
    } on PlatformException catch (error) {
      print(error);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImg({required File imgFile}) async {
    CroppedFile? croppedImg =
        await ImageCropper().cropImage(sourcePath: imgFile.path);

    if (croppedImg == null) return null;
    return File(croppedImg.path);
  }


  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectImageOptionsWidget(
                onTap: _pickImg,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(28),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showSelectPhotoOptions(context);
                    },
                    child: Center(
                      child: Container(
                        height: 600,
                        width: 500,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: Center(
                            child: _image == null
                                ? Text(
                                    selectPhotoTitile,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                : Image(image: FileImage(_image!))),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectPhotoButton(
                    onTap: () => _showSelectPhotoOptions(context),
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    textLabel: selectPhotoTitile,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
