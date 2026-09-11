import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'Screen/PreviewScreen.dart';
import 'Screen/SignUpScreen.dart';
import 'Screen/firstPage.dart';
import 'Screen/formPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(MyApp(camera: cameras.first));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({
    super.key,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Camera',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: FormPage(camera:  camera)
    );
  }
}