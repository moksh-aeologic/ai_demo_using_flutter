import 'package:ais_demo/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import '../res/strings.dart';

class PoseEstimation extends StatefulWidget {
  const PoseEstimation({super.key});

  @override
  State<PoseEstimation> createState() => _PoseEstimationState();
}

class _PoseEstimationState extends State<PoseEstimation> {
  late CameraImage imgcamera;
  late CameraController cameraController;
  bool isWorking = false;
  late double imgHeight;
  late double imgWidth;
  List? reconginitions;
  late Size size;
  List<Widget> stackWidgetsList = [];

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.stopImageStream();
    Tflite.close();
  }

  initCamera() async {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      cameraController.startImageStream((imageFromStream) {
        if (!isWorking) {
          isWorking = true;
          imgcamera = imageFromStream;
          addData();
          runModelOnFrame();
          setState(() {});
        }
      });
    });
  }

  runModelOnFrame() async {
    imgHeight = imgcamera.height + 0.0;
    imgWidth = imgcamera.width + 0.0;
    reconginitions = await Tflite.runPoseNetOnFrame(
      bytesList: imgcamera.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: imgcamera.height,
      imageWidth: imgcamera.width,
      numResults: 2,
    );
    
    isWorking = false;
    setState(() => imgcamera);
  }

  loadModel() async {
    Tflite.close();
    try {
      String? response;
      response = await Tflite.loadModel(
        model: TFModels.poseEstimationModel,
        // labels: TFLabels.faceMaskLabel,
      );
      print(response);
    } catch (e) {
      print("Unable to load Models");
    }
  }

  addData() {
    stackWidgetsList.add(
      Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height,
        child: Container(
          child: (cameraController.value.isInitialized)
              ? AspectRatio(
                  aspectRatio: cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                )
              : Container(),
        ),
      ),
    );
  }

  List<Widget> displayKeyPoints(Size screen) {
    if (reconginitions == null) {
      return [];
    }

    if (imgWidth == null) {
      return [];
    }
    double factorX = screen.width;
    double factorY = imgHeight;

    var lists = <Widget>[];
    reconginitions?.forEach((result) {
      var list = result["keypoints"].values.map<Widget>((val) {
        return Positioned(
          left: val["x"] * factorX - 6,
          top: val["y"] * factorY - 6,
          width: 100,
          height: 20,
          child: Text(
            "◉ ${val['part']}",
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 17,
            ),
          ),
        );
      }).toList();
      lists.addAll(list);
    });
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    stackWidgetsList.addAll(displayKeyPoints(size));
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.black,
        child: Stack(children: stackWidgetsList),
      ),
    );
  }
}
