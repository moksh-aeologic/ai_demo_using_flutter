import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:ais_demo/main.dart';
import 'package:ais_demo/res/strings.dart';

class FaceMaskDetectorScreen extends StatefulWidget {
  const FaceMaskDetectorScreen({super.key});

  @override
  State<FaceMaskDetectorScreen> createState() => _FaceMaskDetectorScreenState();
}

class _FaceMaskDetectorScreenState extends State<FaceMaskDetectorScreen> {
  late CameraImage imgcamera;
  late CameraController cameraController;
  bool isWorking = false;
  String result = "";

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((image) {
          if (!isWorking) {
            isWorking = true;
            imgcamera = image;
            runModelOnFrame();
          }
        });
      });
    });
  }

  runModelOnFrame() async {
    var reconginitions = await Tflite.runModelOnFrame(
      bytesList: imgcamera.planes.map((e) {
        return e.bytes;
      }).toList(),
      imageHeight: imgcamera.height,
      imageWidth: imgcamera.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      threshold: .1,
      asynch: true,
    );
    result = "";

    for (var element in reconginitions!) {
      result += element["label"];
    }

    setState(() => result);
  }

  @override
  void initState() {
    super.initState();
    print("Home");
    initCamera();
    loadModel();
  }

  loadModel() async {
    try {
      String? response;
      response = await Tflite.loadModel(
        model: TFModels.faceMaskModel,
        labels: TFLabels.faceMaskLabel,
      );
      print(response);
    } catch (e) {
      print("Unable to load Models");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(result)),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: size.height - 100,
            width: size.width,
            child: SizedBox(
              height: size.height - 100,
              child: (!cameraController.value.isInitialized)
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
