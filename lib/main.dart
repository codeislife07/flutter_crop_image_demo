import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cropp Image Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedFilePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          
          
          
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.4),
            child: Center(
              child: Visibility(
                visible: selectedFilePath.isNotEmpty,
                child: Image.file(
                  File(selectedFilePath),
                ),
              ),
            ),
          ),



          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              var image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              selectedFilePath = image?.path ?? "";
              setState(() {});
            },
            child: const Text("Select image"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              cropImage();
            },
            child: const Text("Crop image"),
          )
        ],
      ),
    );
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedFilePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    selectedFilePath = croppedFile?.path ?? selectedFilePath;
    setState(() {});
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {Pflutter
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
