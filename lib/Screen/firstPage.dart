import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_screen/Manager/manager.dart';

import 'VideoScreen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  late CameraDescription frontCamera;

  bool cameraReady = false;
  int currentPhoto = 0;
  bool photosCompleted = false;
  bool photoTaken = false;

  XFile? capturedImage;

  List<XFile> list = [];

  double scale = 1.0;
  double baseScale = 1.0;

  bool torchOn = false;
  bool font = false;
  bool confirm = false;
  bool screenflash = false;

  double? latitude;
  double? longitude;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startCamera();
      _determinePosition();
    });
  }

  Future<void> _determinePosition() async {
    print("LOCATION FUNCTION STARTED");

    LocationPermission permission = await Geolocator.checkPermission();

    print("CURRENT PERMISSION: $permission");

    if (permission == LocationPermission.denied) {
      print("REQUESTING LOCATION PERMISSION...");

      permission = await Geolocator.requestPermission();

      print("AFTER REQUEST: $permission");
    }

    if (permission == LocationPermission.deniedForever) {
      print("PERMISSION DENIED FOREVER");
      return;
    }

    if (permission == LocationPermission.denied) {
      print("LOCATION PERMISSION DENIED");
      return;
    }

    print("LOCATION PERMISSION GRANTED");

    Position position = await Geolocator.getCurrentPosition();

    latitude = position.latitude;
    longitude = position.longitude;

    print("LATITUDE: $latitude");
    print("LONGITUDE: $longitude");
  }

  Future<void> startCamera() async {
    try {
      controller = CameraController(
        widget.camera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        cameraReady = true;
      });
    } catch (e) {
      print("START CAMERA ERROR: $e");
    }
  }

  Future<void> takePhoto() async {
    if (!cameraReady) {
      return;
    }

    setState(() {
      screenflash = true;
    });

    final image = await controller.takePicture();

    await controller.setFlashMode(FlashMode.off);

    setState(() {
      capturedImage = image;
      photoTaken = true;
      torchOn = false;
      screenflash = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void retakePhoto() {
    setState(() {
      capturedImage = null;
      photoTaken = false;
    });
  }

  void confirmPhoto() {
    list.add(capturedImage!);

    if (currentPhoto == 5) {

      manager().insertimage(list) ;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Videoscreen(),
        ),
      );

      return;
    }


    setState(() {
      currentPhoto++;
      capturedImage = null;
      photoTaken = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraReady) {
      return const Scaffold(
        backgroundColor: Colors.black,

        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (details) async {
              baseScale = scale;
            },

            onScaleUpdate: (details) async {
              double newscale = baseScale * details.scale;

              if (newscale < 1.0) {
                newscale = 1.0;
              }

              if (newscale > 5.0) {
                newscale = 5.0;
              }

              setState(() {
                scale = newscale;
              });

              await controller.setZoomLevel(scale);
            },

            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(controller),
            ),
          ),

          IgnorePointer(
            child: AnimatedOpacity(
              opacity: screenflash ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Container(color: Colors.white),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          "${currentPhoto + 1}/6 Photos",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          await controller.setFlashMode(
                            torchOn ? FlashMode.off : FlashMode.torch,
                          );

                          setState(() {
                            torchOn = !torchOn;
                          });
                        },

                        child: CircleAvatar(
                          backgroundColor: Colors.black54,

                          child: Icon(
                            torchOn ? Icons.flash_off : Icons.flash_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              color: Colors.black87,
              child: Column(
                children: [
                  Slider(
                    value: scale,
                    min: 1.0,
                    max: 5.0,
                    onChanged: (value) async {
                      setState(() {
                        scale = value;
                      });

                      await controller.setZoomLevel(value);
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: photoTaken
                              ? GestureDetector(
                                  onTap: () {
                                    retakePhoto();
                                  },
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 35,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Retake",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : list.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                children: [
                                                  Image.file(
                                                    File(list.last.path),
                                                  ),

                                                  Positioned(
                                                    bottom: 8,
                                                    right: 8,
                                                    child: Container(
                                                      child: Text(
                                                        "Lat: $latitude\nLng: $longitude",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    list.removeLast();
                                                    currentPhoto--;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Delete"),
                                              ),

                                              const SizedBox(height: 4),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.file(
                                      File(list.last.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if (!photoTaken) {
                            takePhoto();
                          }
                        },
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: photoTaken ? Colors.grey : Colors.white,
                            border: Border.all(color: Colors.grey, width: 4),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: photoTaken
                              ? GestureDetector(
                                  onTap: () {
                                    confirmPhoto();

                                  },
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 35,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    font = !font;

                                    await controller.dispose();

                                    await startCamera();
                                  },
                                  icon: const Icon(
                                    Icons.flip_camera_android,
                                    color: Colors.white,
                                  ),
                                  iconSize: 28,
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "${currentPhoto + 1} of 6 captured",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
