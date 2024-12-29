import 'package:camera/camera.dart';
import 'package:face_detection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = " ";
  Interpreter? interpreter;

  @override
  void initState() {
    super.initState();
    loadingModel();
    requestPermissions();
  }

  loadCamera() {
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );

    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    }).catchError((e) {
      print("Error initializing camera: $e");
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.camera.request().isGranted) {
      loadingModel();
    } else {
      print('Camera permission denied');
    }
  }



  stopCamera() {
    if(cameraController != null && cameraController!.value.isInitialized) {
      cameraController!.stopImageStream();
      cameraController!.dispose();
      cameraController = null;

      setState(() {
        cameraImage = null;
      });
    }
  }

  runModel() async {
    if (cameraImage != null && interpreter != null) {
      var planes = cameraImage!.planes;
      final yuvBytes = planes[0].bytes + planes[1].bytes + planes[2].bytes;

      final input = yuvBytes.reshape([1, cameraImage!.height, cameraImage!.width, 3]);
      var outputData = List.filled(2, 0).reshape([1, 2]);
      interpreter!.run(input, outputData);

      setState(() {
        output = outputData[0][0].toString();
      });
      print("Predicted Output : $output");
    }
  }

  loadingModel() async {
    try {
      final ByteData data = await rootBundle.load('assets/model_unquant.tflite');
      print("Asset data length: ${data.lengthInBytes}");
      interpreter = await Interpreter.fromBuffer(data.buffer.asUint8List());
      print("Model loaded successfully");
    } catch (e, stacktrace) {
      print("Error loading model : $e");
      print("Stack trace: $stacktrace");
    }
  }

  @override
  void dispose() {
    stopCamera();
    interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double padding = width * 0.05;
    final double fontSize = width * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        centerTitle: true,
        title: Text(
          "Live Emotion Detection",
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: SizedBox(
              height: height * 0.7,
              width: width * 0.9,
              child: cameraController == null || !cameraController!.value.isInitialized
                  ? Center(child: Text("Camera not opened"),)
                  : AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              ),
            ),
          ),
          Text(
            output.isEmpty ? "No output detected" : "Face Expression : $output",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  loadCamera();
                },
                child: Text("Start Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  stopCamera();
                },
                child: Text("Stop Camera"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
