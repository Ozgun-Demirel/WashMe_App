


import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHelper{

  static Future<File?> takePicture() async {
    var picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    if (image == null) return null;
    return  await _saveImagePermanently(image.path);

  }

  static Future<File?> selectPicture() async {
    var picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);
    if (image == null) return null;
    return  await _saveImagePermanently(image.path);
  }

  static Future<File> _saveImagePermanently(String imagePath) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String name = basename(imagePath);
    final File image = File('${directory.path}/$name');

    await GallerySaver.saveImage(imagePath, toDcim: true);

    return await File(imagePath).copy(image.path);
  }

}