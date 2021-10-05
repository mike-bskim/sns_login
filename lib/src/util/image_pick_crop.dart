import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_login/src/controller/login_user_controller.dart';

class ImagePickCrop {

  static Future getImage() async {
    final LoginUserController _loginUserCtrl = Get.put(LoginUserController());
    XFile? _image;
    var newImagePath = '';

    final image = await ImagePicker().pickImage(
      //PickedFile ==> final
      source: ImageSource.gallery,
      maxHeight: 800,
    );

    if (image != null) {
      _image = image;
      if(_loginUserCtrl.isMobile) {
        newImagePath = await _cropImage(image);
      }

    } else {
      print('No image selected.');
    }

//    print('_getImage >> _image!.path: ' + _image!.path.toString());
//    print('_getImage >> newImagePath: ' + newImagePath ?? 'Not mobile');

    if(_loginUserCtrl.isMobile) {
      return newImagePath;
//      _loginUserCtrl.changeNewPhotoURL(newImagePath);
    } else {
      return _image;
//      _loginUserCtrl.changeNewPhotoURL(_image!.path);
    }

  }


  static Future _cropImage(XFile? picked) async {
    var cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.red,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
//        lockAspectRatio: false,// no use
      ),
      sourcePath: picked!.path,
      aspectRatioPresets: [
//        CropAspectRatioPreset.original,// no use
//        CropAspectRatioPreset.square,// no use
//        CropAspectRatioPreset.ratio16x9,// no use
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 600,
    );
    if (cropped != null) {
      print('cropped >>> ' + cropped.path.toString());
      return cropped.path;
    }
  }
}
