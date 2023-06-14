import 'package:flutter/material.dart';
import '../common/buttons.dart';
import 'package:image_picker/image_picker.dart';


class SelectImageOptionsWidget extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const SelectImageOptionsWidget({
    Key? key,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -16,
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: Colors.grey),
            ),
          ),
          Column(
            children: [
              SelectPhotoButton(
                onTap: () => onTap(ImageSource.gallery),
                // icon: Icons.image,
                textLabel: "Gallery",
                textColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(
                height: 10,
              ),
              SelectPhotoButton(
                onTap: () => onTap(ImageSource.camera),
                // icon: Icons.image,
                textLabel: "Take a picture",
                textColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
