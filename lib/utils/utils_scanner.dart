import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';

class UtilsScanner {
  UtilsScanner._();
  static Future<CameraDescription> getCamera(
      CameraLensDirection cameraLensDescription) async {
    return await availableCameras().then((List<CameraDescription> camera) =>
        camera.firstWhere((CameraDescription description) =>
            description.lensDirection == cameraLensDescription));
  }

  static Future<dynamic> detect({
    required CameraImage image,
    required Future<dynamic> Function(GoogleVisionImage image) detectInImage,
    required int imageRotation,
  }) {
    return detectInImage(
      GoogleVisionImage.fromBytes(
        concatePlanes(image.planes),
        buildMetaData(
          image,
          rotationToImage(imageRotation),
        ),
      ),
    );
  }

  static Uint8List concatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane element in planes) {
      allBytes.putUint8List(element.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static GoogleVisionImageMetadata buildMetaData(
      CameraImage image, ImageRotation rotation) {
    return GoogleVisionImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rawFormat: image.format.raw,
      rotation: rotation,
      planeData: image.planes
          .map(
            (Plane plane) => GoogleVisionImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            ),
          )
          .toList(),
    );
  }

  static ImageRotation rotationToImage(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;

      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;
    }
  }
}
