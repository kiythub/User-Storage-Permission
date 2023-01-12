import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? _image;

  Future selectImage() async {
    final XFile? selectedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);
      });
    }
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      selectImage();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission Denied'),
            backgroundColor: Colors.redAccent,
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Storage Permission'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 450,
              child: _image != null
                  ? Image.file(_image!,
                  fit: BoxFit.cover
              )
                  : const Text('No Image Selected.'),
            )
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: _getStoragePermission,
                label: const Text('Gallery'),
                icon: const Icon(Icons.photo_library_outlined),
              ),
            ),
          )
        ]
      ),
    );
  }
}
