import 'package:ais_demo/screens/captions_generator.dart';
import 'package:ais_demo/screens/face_mask_detector.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';
import 'face_detector.dart';
import 'live_object_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Artificial intelligence"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Image.asset(
              drawerImage,
              fit: BoxFit.cover,
              height: 200,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(faceMaskImage),
              ),
              title: const Text("Face Mask Detector"),
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FaceMaskDetectorScreen())),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(faceMaskImage),
              ),
              title: const Text("Live Object Detector"),
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LiveObjectDetectorScreen()),
                  (Route<dynamic> route) => false),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(faceDetectionImage),
              ),
              title: const Text("Face Detection"),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const FaceDetectorScreen()),
                (Route<dynamic> route) => false,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(faceMaskImage),
              ),
              title: const Text("Captions Generator"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CaptionsGeneratorScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
