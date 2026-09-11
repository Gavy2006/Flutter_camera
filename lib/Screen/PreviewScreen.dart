import 'dart:io';

import 'package:local_auth/local_auth.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_screen/Manager/manager.dart';

class Previewscreen extends StatefulWidget {


  const Previewscreen({super.key});

  @override
  State<Previewscreen> createState() => _PreviewscreenState();
}

class _PreviewscreenState extends State<Previewscreen> {
  int index = 0;

  String? file;
  List<String> list = [];

  late final LocalAuthentication auth;

  Future<void> loadData() async {

    final images = await manager().returnimages();
    final video = await manager().returnvideo();


    setState(() {
      list = images;
      file = video;
    });

    videoController = VideoPlayerController.file(
      File(file!),
    );

    await videoController.initialize();

    setState(() {});
  }

  List<Map<String , dynamic>> listno = [] ;
  List<Map<String , dynamic>> describe = [] ;

  Future<void> listdetails() async{

    List<Map<String , dynamic>> listno1 = await manager().returndetails() ;
    List<Map<String , dynamic>> describe1 = await manager().returndescribe() ;


    setState(() {
      listno= listno1 ;
       describe = describe1 ;
    });

  }

  Future<void> registerBiometric() async {
    try {
      final bool success = await auth.authenticate(
        localizedReason: 'Register your fingerprint to continue',
      );

      if (success) {

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Images Submitted"))
        ) ;

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("failed to submit"))
        ) ;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  late VideoPlayerController videoController;

  @override
  void initState() {

    super.initState();
    auth = LocalAuthentication();
    listdetails();

    loadData() ;
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Images"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                  "Policy Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 16),

            Text(
              "Name: ${listno.isNotEmpty ? listno.first['name'] ?? '' : ''}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Policy No: ${listno.isNotEmpty ? listno.first['policyno'] ?? '' : ''}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            Text(
              "Description: ${describe.isNotEmpty ? describe.first['describe'] ?? '' : ''}",
              style: const TextStyle(fontSize: 16),
            ),
          ],


        ),
      ),

      const SizedBox(height: 16),

      Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Photos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Check out all captured images here",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[0]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 1"),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[1]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 2"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[2]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 3"),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[3]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 4"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[4]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 5"),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(list[5]),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("Image 6"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Video Shared",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Container(
                width: 330,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Video",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "Check out all captured Video here",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 14),

                    videoController.value.isInitialized
                        ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 290,
                          height: 180,
                          child: VideoPlayer(videoController),
                        ),
                      ),
                    )
                        : const SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await videoController.seekTo(
                              videoController.value.position -
                                  const Duration(seconds: 10),
                            );
                          },
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.black,
                            size: 26,
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
                            color: Colors.black,
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
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ) ,

            const SizedBox(height: 15),

            Center(

              child: ElevatedButton(onPressed: (){
                registerBiometric() ;
              }, child: Text("Submit")),
            )
          ],
        ),
      ),
    );
  }
}
