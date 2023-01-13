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
  CameraController? cameraController;
  bool isWorking = false;
  late FaceDetector faceDetector;
  late Size size;
  late List<Face> facesList;
  late CameraDescription description;
  late CameraLensDirection cameraLensDirection = CameraLensDirection.front;

  initCamera() async {
    description = await UtilsScanner.getCamera(cameraLensDirection);
    cameraController = CameraController(description, ResolutionPreset.medium);
    faceDetector = GoogleVision.instance.faceDetector(const FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: .1,
      mode: FaceDetectorMode.fast,
    ));

    await cameraController?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      cameraController?.startImageStream((image) {
        if (!isWorking) {
          isWorking = true;
          setState(() {});
          addData();
          performDetection(image);
        }
      });
    });
  }

  dynamic scanResults;
  performDetection(CameraImage image) async {
    UtilsScanner.detect(
      image: image,
      detectInImage: faceDetector.processImage,
      imageRotation: description.sensorOrientation,
    ).then((result) {
      setState(() {
        scanResults = result;
      });
    }).whenComplete(() => isWorking = false);
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    faceDetector.close();
    super.dispose();
  }

  List<Widget> stackWidgetsList = [];
  addData() {
    stackWidgetsList.add(
      Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height - 250,
        child: Container(
          child: (cameraController!.value.isInitialized)
              ? AspectRatio(
                  aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),
                )
              : Container(),
        ),
      ),
    );
    stackWidgetsList.add(
      Positioned(
        child: buildResult(),
        top: 0,
        left: 0,
        width: size.width,
        height: size.height,
      ),
    );
  }

  buildResult() {
    if (scanResults == null ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return const Text("");
    }
    final Size imageSize = Size(
      cameraController!.value.previewSize!.height,
      cameraController!.value.previewSize!.width,
    );
    CustomPainter customPainter =
        FaceDetectorPainter(imageSize, cameraLensDirection, scanResults);
    return CustomPaint(painter: customPainter);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.black,
        child: Stack(children: stackWidgetsList),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: toggleCameraFrontOrBack, child: const Icon(Icons.cached)),
    );
  }

  toggleCameraFrontOrBack() async {
    if (cameraLensDirection == CameraLensDirection.back) {
      CameraLensDirection.front;
    } else {
      cameraLensDirection = CameraLensDirection.back;
    }
    await cameraController?.stopImageStream();
    await cameraController?.dispose();

    setState(() => cameraController = null);

    await initCamera();
  }
}

class FaceDetectorPainter extends CustomPainter {
  final Size absoluteImageSize;
  CameraLensDirection cameraLensDirection;
  final List<Face> faces;
  FaceDetectorPainter(
      this.absoluteImageSize, this.cameraLensDirection, this.faces);
  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .2
      ..color = Colors.red;

    for (Face face in faces) {
      canvas.drawRect(
          Rect.fromLTRB(
            cameraLensDirection == CameraLensDirection.front
                ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
                : face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            cameraLensDirection == CameraLensDirection.front
                ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
                : face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          paint);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }

  @override
  bool shouldRebuildSemantics(FaceDetectorPainter oldDelegate) => false;
}
