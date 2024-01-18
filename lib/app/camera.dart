import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:reciperator/routes/router_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Uint8List? _capturedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final size = MediaQuery.of(context).size;
            var scale = size.aspectRatio * _controller.value.aspectRatio;
            if (scale < 1){
              scale = 1 / scale;
            } 
            // If the Future is complete, display the preview.
            return Center(
                child: CameraPreview(_controller),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            _capturedImage = await File(image.path).readAsBytes();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imageData: _capturedImage,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            debugPrint('$e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List? imageData;

  const DisplayPictureScreen({Key? key, required this.imageData})
      : super(key: key);

  Future<void> addphoto(Uint8List imageBytes, BuildContext context) async {
    //refernce to storage
    String uid = FirebaseAuth.instance.currentUser!.uid;
    //problem here
    try{
      final reference = FirebaseStorage.instance.ref().child('images/$uid.jpg');
      await reference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final imageUrl = await reference.getDownloadURL();
    debugPrint('Image uploaded to Firebase Storage. URL: $imageUrl');
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'image': imageUrl});
    Navigator.pushReplacementNamed(context, homeRoute);
    }
    catch (e) {
      debugPrint('$e');
      return;
    }
  }


  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: null,
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            imageData != null
              ? Image.memory(
                  imageData!,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                )
              : const Center(child: Text('No image data')),
            Positioned(
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: () async {
                  await addphoto(imageData!, context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}