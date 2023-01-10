import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import '../main.dart';
import '../res/strings.dart';

class LiveObjectDetectorScreen extends StatefulWidget {
  const LiveObjectDetectorScreen({super.key});

  @override
  State<LiveObjectDetectorScreen> createState() =>
      _LiveObjectDetectorScreenState();
}

class _LiveObjectDetectorScreenState extends State<LiveObjectDetectorScreen> {
  late CameraImage imgcamera;
  late CameraController cameraController;
  bool isWorking = false;
  late double imgHeight;
  late double imgWidth;
  List? reconginitions;

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  loadModel() async {
    Tflite.close();
    try {
      String? response;
      response = await Tflite.loadModel(
        model: TFModels.liveObjectModel,
        labels: TFLabels.liveObjectLabel,
      );
      print(response);
    } catch (e) {
      print("Unable to load Models");
    }
  }

  initCamera() {
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((image) {
          if (!isWorking) {
            isWorking = true;
            imgcamera = image;
            runModelOnStreamFrame();
          }
        });
      });
    });
  }

  runModelOnStreamFrame() async {
    imgHeight = imgcamera.height + 0.0;
    imgWidth = imgcamera.width + 0.0;
    reconginitions = await Tflite.detectObjectOnFrame(
      bytesList: imgcamera.planes.map((e) {
        return e.bytes;
      }).toList(),
      model: "SSDMobileNet",
      imageHeight: imgcamera.height,
      imageWidth: imgcamera.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: .4,
    );
    isWorking = false;
    setState(() {
      imgcamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidget = [];
    stackChildrenWidget.add(
      Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height - 100,
        child: SizedBox(
          height: size.height - 100,
          child: (!cameraController.value.isInitialized)
              ? Container()
              : AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
        ),
      ),
    );
    stackChildrenWidget.addAll(displayBoxes(size));
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: stackChildrenWidget),
    );
  }

  List<Widget> displayBoxes(Size screen) {
    if (reconginitions == null) return [];
    if (imgWidth == null) return [];
    double factorX = screen.width;
    double factorY = imgHeight;
    return reconginitions!.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.pink, width: 2),
          ),
          child: Text(
            "${result['detectedClass']}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList();
  }
}
