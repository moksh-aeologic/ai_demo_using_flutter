import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CaptionsGeneratorScreen extends StatefulWidget {
  const CaptionsGeneratorScreen({super.key});

  @override
  State<CaptionsGeneratorScreen> createState() =>
      _CaptionsGeneratorScreenState();
}

class _CaptionsGeneratorScreenState extends State<CaptionsGeneratorScreen> {
  bool loading = false;
  File? image;
  String resultTxt = "Fetching result....";
  late Size size;
  final imagePicker = ImagePicker();

  pickImageFromGallery() async {
    var imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });
    }
  }

  pickImageFromCamera() async {
    var imageFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: loading
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 500,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IconButton(
                              //     onPressed: () {
                              //       resultTxt = "Fetching results..";
                              //       loading = true;
                              //       setState(() {});
                              //     },
                              //     icon: const Icon(Icons.arrow_back)),
                              SizedBox(
                                width: size.width,
                                child: ClipRRect(
                                  child: image == null
                                      ? Container()
                                      : Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            resultTxt,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "1",
            onPressed: pickImageFromCamera,
            child: const Icon(Icons.camera_alt_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "2",
            onPressed: pickImageFromGallery,
            child: const Icon(Icons.image_outlined),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "3",
            onPressed: () {
              resultTxt = "Fetching results..";
              loading = true;
              setState(() {});
            },
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}
