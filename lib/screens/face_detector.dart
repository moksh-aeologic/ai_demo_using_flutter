import 'package:ais_demo/utils/utils_scanner.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class FaceDetectorScreen extends StatefulWidget {
  const FaceDetectorScreen({super.key});

  @override
  State<FaceDetectorScreen> createState() => _FaceDetectorScreenState();
}

class _FaceDetectorScreenState extends State<FaceDetectorScreen> {
  late CameraController cameraController;
  bool isWorking = false;
  late FaceDetector faceDetector;
  late Size size;
  late List<Face> facesList;
  late CameraDescription description;
  late CameraLensDirection cameraLensDirection;

  initCamera() async {
    description = await UtilsScanner.getCamera(cameraLensDirection);
    cameraController = CameraController(description, ResolutionPreset.medium);
    faceDetector = GoogleVision.instance.faceDetector(const FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: .1,
      mode: FaceDetectorMode.fast,
    ));
    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      cameraController.startImageStream((image) {
        if (!isWorking) {
          isWorking = true;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgetsList = [];
    size = MediaQuery.of(context).size;
    stackWidgetsList.add(Positioned(
      top: 0,
      left: 0,
      width: size.width,
      height: size.height - 250,
      child: Container(
        child: (cameraController.value.isInitialized)
            ? AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              )
            : Container(),
      ),
    ));
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.black,
        child: Stack(children: stackWidgetsList),
      ),
    );
  }
}
