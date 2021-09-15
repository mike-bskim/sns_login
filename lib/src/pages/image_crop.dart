//import 'dart:io';

import 'dart:io';

import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:image_picker/image_picker.dart';

class ImageCrop extends StatefulWidget {

  final imageFrom;

//  const ImageCrop(XFile image, {Key? key, this.image}) : super(key: key);
  const ImageCrop({Key? key, required this.imageFrom}) : super(key: key);

  @override
  _ImageCropState createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  final controller = CropController(aspectRatio: 1000 / 667.0);
  double _rotation = 0;
  BoxShape shape = BoxShape.rectangle;

  late String imageDisplay ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageDisplay = widget.imageFrom;
    print('imageDisplay: ' + imageDisplay.toString());
  }

  void _cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);

    print('_cropImage>>>');
    print(cropped);
    Get.back( result: cropped.toByteData());

//    Navigator.of(context).push(
//      MaterialPageRoute(
//        builder: (context) => Scaffold(
//          appBar: AppBar(
//            title: const Text('Crop Result'),
//            centerTitle: true,
//            actions: [
//              Builder(
//                builder: (context) => IconButton(
//                  icon: const Icon(Icons.save),
//                  onPressed: () {
//                    print('_cropImage>>>');
//                    print(cropped);
//                    Get.back( result: cropped);
//                  },
//                ),
//              ),
//            ],
//          ),
//          body: Center(
//            child: RawImage(
//              image: cropped,
//            ),
//          ),
//        ),
//        fullscreenDialog: true,
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Demo'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            print('나중에 지울것');
            Get.back();
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _cropImage,
            tooltip: 'Crop',
            icon: const Icon(Icons.crop),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8),
              child: Crop(
                onChanged: (decomposition) {
                  if (_rotation != decomposition.rotation) {
                    setState(() {
                      _rotation = ((decomposition.rotation + 180) % 360) - 180;
                    });
                  }

                  // print(
                  //     "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                },
                controller: controller,
                shape: shape,
// FileImage(File(_loginUserCtrl.newPhotoURL)) as ImageProvider / Image.file(imageDisplay.path),
                child: Image.file(File(imageDisplay)),
                /* It's very important to set `fit: BoxFit.cover`.
                   Do NOT remove this line.
                   There are a lot of issues on github repo by people who remove this line and their image is not shown correctly.
                */
                foreground: IgnorePointer(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: const Text(
                      'Foreground Object',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                helper: shape == BoxShape.rectangle
                    ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                )
                    : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: () {
                  controller.rotation = 0;
                  controller.scale = 1;
                  controller.offset = Offset.zero;
                  setState(() {
                    _rotation = 0;
                  });
                },
              ),
//              Expanded(
//                child: SliderTheme(
//                  data: theme.sliderTheme.copyWith(
//                    trackShape: CenteredRectangularSliderTrackShape(),
//                  ),
//                  child: Slider(
//                    divisions: 360,
//                    value: _rotation,
//                    min: -180,
//                    max: 180,
//                    label: '$_rotation°',
//                    onChanged: (n) {
//                      setState(() {
//                        _rotation = n.roundToDouble();
//                        controller.rotation = _rotation;
//                      });
//                    },
//                  ),
//                ),
//              ),
              PopupMenuButton<BoxShape>(
                icon: const Icon(Icons.crop_free),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Box"),
                    value: BoxShape.rectangle,
                  ),
                  const PopupMenuItem(
                    child: Text("Oval"),
                    value: BoxShape.circle,
                  ),
                ],
                tooltip: 'Crop Shape',
                onSelected: (x) {
                  setState(() {
                    shape = x;
                  });
                },
              ),
              PopupMenuButton<double>(
                icon: const Icon(Icons.aspect_ratio),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text("Original"),
                    value: 1000 / 667.0,
                  ),
//                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    child: Text("16:9"),
                    value: 16.0 / 9.0,
                  ),
                  const PopupMenuItem(
                    child: Text("4:3"),
                    value: 4.0 / 3.0,
                  ),
                  const PopupMenuItem(
                    child: Text("1:1"),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text("3:4"),
                    value: 3.0 / 4.0,
                  ),
                  const PopupMenuItem(
                    child: Text("9:16"),
                    value: 9.0 / 16.0,
                  ),
                ],
                tooltip: 'Aspect Ratio',
                onSelected: (x) {
                  controller.aspectRatio = x;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
