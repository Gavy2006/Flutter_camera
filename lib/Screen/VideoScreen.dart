import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_manager/photo_manager.dart';

import 'PreviewScreen.dart';

class Videoscreen extends StatefulWidget {
  final List<XFile> list;
  const Videoscreen({super.key, required this.list});

  @override
  State<Videoscreen> createState() => _VideoscreenState();
}

class _VideoscreenState extends State<Videoscreen> {
  late CameraController controller;

  List<AssetEntity> videos = [];

  Future<void> fetchvideo() async {
    try {
      print("========== GALLERY START ==========");

      final permission = await PhotoManager.requestPermissionExtend();

      print("PERMISSION: ${permission.isAuth}");
      print("PERMISSION TYPE: $permission");

      if (!permission.isAuth && permission != PermissionState.limited) {
        print("❌ GALLERY PERMISSION DENIED");
        return;
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        hasAll: true,
      );

      print("ALBUM COUNT: ${albums.length}");

      for (final album in albums) {
        print("ALBUM: ${album.name}");
        print("COUNT: ${await album.assetCountAsync}");
      }

      if (albums.isEmpty) {
        print("❌ NO VIDEO ALBUM");
        return;
      }

      // All videos, not only first album
      final List<AssetEntity> allVideos = [];

      for (final album in albums) {
        final albumVideos = await album.getAssetListRange(start: 0, end: 20);

        allVideos.addAll(albumVideos);
      }

      print("TOTAL VIDEOS FOUND: ${allVideos.length}");

      if (!mounted) return;

      setState(() {
        videos = allVideos;
      });

      print("VIDEOS SET IN UI: ${videos.length}");
      print("========== GALLERY END ==========");
    } catch (e, stackTrace) {
      print("❌ GALLERY ERROR: $e");
      print(stackTrace);
    }
  }

  String? cameraError;
  bool cameraReady = false;
  bool isRecording = false;
  bool videoTaken = false;
  bool torchOn = false;

  XFile? recordedVideo;
  bool font = false;
  late CameraDescription frontCamera;
  double scale = 1.0;
  double baseScale = 1.0;
  int seconds = 0;



  Future<void> startCamera() async {
    try {
      print("1. Getting cameras...");

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception("No camera found on this device");
      }

      print("2. Cameras found: ${cameras.length}");

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      print("3. Creating controller...");

      controller = CameraController(
        font ? frontCamera : backCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      print("4. Initializing camera...");

      await controller.initialize();

      print("5. Camera initialized!");

      if (!mounted) return;

      setState(() {
        cameraReady = true;
        cameraError = null;
      });
    } catch (e) {
      print("CAMERA ERROR: $e");

      if (!mounted) return;

      setState(() {
        cameraReady = false;
        cameraError = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    try {
      await startCamera();

      fetchvideo();
    } catch (e) {
      print("CAMERA ERROR: $e");
    }
  }

  Future<void> startRecording() async {
    if (!cameraReady || isRecording || videoTaken) {
      return;
    }

    await controller.startVideoRecording();

    setState(() {
      isRecording = true;
      seconds = 0;
    });

    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (!isRecording) {
        return false;
      }

      if (seconds >= 89) {
        await stopRecording();
        return false;
      }

      if (mounted) {
        setState(() {
          seconds++;
        });
      }

      return true;
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording) {
      return;
    }

    final XFile video = await controller.stopVideoRecording();
    await controller.setFlashMode(FlashMode.off);

    if (!mounted) return;

    setState(() {
      isRecording = false;
      videoTaken = true;
      recordedVideo = video;
      torchOn = false;
    });
  }

  void retakeVideo() {
    setState(() {
      recordedVideo = null;
      videoTaken = false;
      seconds = 0;
    });
  }

  void confirmVideo() {
    if (recordedVideo == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Previewscreen(list: widget.list, file: recordedVideo!),
      ),
    );
  }

  String formatTime(int value) {
    final minutes = value ~/ 60;
    final remainingSeconds = value % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    if (cameraReady) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoTaken && recordedVideo != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPreview(videoPath: recordedVideo!.path),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      child: const Text(
                        "Video Preview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: retakeVideo,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, color: Colors.red, size: 38),
                        SizedBox(height: 5),
                        Text(
                          "Retake",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: confirmVideo,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 38),
                        SizedBox(height: 5),
                        Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ================= CAMERA AREA =================
          Expanded(
            child: Stack(
              children: [
                // CAMERA PREVIEW
                Positioned.fill(
                  child: GestureDetector(
                    onScaleStart: (details) {
                      baseScale = scale;
                    },

                    onScaleUpdate: (details) async {
                      double newScale = baseScale * details.scale;

                      if (newScale < 1.0) {
                        newScale = 1.0;
                      }

                      if (newScale > 5.0) {
                        newScale = 5.0;
                      }

                      setState(() {
                        scale = newScale;
                      });

                      await controller.setZoomLevel(scale);
                    },

                    child: cameraReady
                        ? CameraPreview(controller)
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),

                // ================= TOP BAR =================
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
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
                          child: const Text(
                            "Video Recording",
                            style: TextStyle(
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

                            if (!mounted) return;

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
                  ),
                ),

                // ================= RECORDING TIMER =================
                if (isRecording)
                  Positioned(
                    top: 110,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${formatTime(seconds)} / 01:30",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // ================= THUMBNAILS =================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<Uint8List?>(
                        future: videos[index].thumbnailDataWithSize(
                          const ThumbnailSize(200, 200),
                        ),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                width: 80,
                                height: 90,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Container(
                              width: 80,
                              height: 90,
                              margin: const EdgeInsets.all(5),
                              color: Colors.grey.shade900,
                              child: const Icon(
                                Icons.video_library,
                                color: Colors.white,
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                snapshot.data!,
                                width: 80,
                                height: 90,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ================= BOTTOM CONTROLS =================
          Container(
            height: 150,
            color: Colors.black87,
            child: Column(
              children: [
                // ZOOM SLIDER
                SizedBox(
                  height: 45,
                  child: Slider(
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
                ),

                // CAMERA BUTTONS
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // GALLERY
                      IconButton(
                        onPressed: () {
                          // Gallery thumbnails are already visible
                        },
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      // RECORD
                      GestureDetector(
                        onTap: () async {
                          if (isRecording) {
                            await stopRecording();
                          } else {
                            await startRecording();
                          }
                        },

                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRecording ? Colors.red : Colors.white,
                            border: Border.all(color: Colors.grey, width: 4),
                          ),

                          child: isRecording
                              ? const Icon(
                                  Icons.stop,
                                  color: Colors.white,
                                  size: 35,
                                )
                              : null,
                        ),
                      ),

                      // FLIP CAMERA
                      IconButton(
                        onPressed: () async {
                          if (isRecording) {
                            return;
                          }

                          font = !font;

                          await controller.dispose();

                          if (!mounted) return;

                          setState(() {
                            cameraReady = false;
                          });

                          await startCamera();
                        },

                        icon: const Icon(
                          Icons.flip_camera_android,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPreview extends StatefulWidget {
  final String videoPath;

  const VideoPreview({super.key, required this.videoPath});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.file(File(widget.videoPath));

    videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!videoController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SizedBox(
      width: 180,
      height: 250,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (videoController.value.isPlaying) {
              videoController.pause();
            } else {
              videoController.play();
            }
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoController.value.size.width,
                  height: videoController.value.size.height,
                  child: VideoPlayer(videoController),
                ),
              ),

              if (!videoController.value.isPlaying)
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 48,
                ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VideoProgressIndicator(
                      videoController,
                      allowScrubbing: true,
                      padding: EdgeInsets.zero,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await videoController.seekTo(
                              videoController.value.position +
                                  const Duration(seconds: 10),
                            );
                          },
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (videoController.value.isPlaying) {
                                videoController.pause();
                              } else {
                                videoController.play();
                              }
                            });
                          },
                          icon: Icon(
                            videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            await videoController.seekTo(
                              videoController.value.position +
                                  const Duration(seconds: 10),
                            );
                          },
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
