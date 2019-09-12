import 'package:align_positioned/align_positioned.dart';
import 'package:camera/camera.dart' as Camera;
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart'
    as NativeOrientation;

class CameraScreen extends StatefulWidget {
  final String baseVideoPath;
  CameraScreen(this.baseVideoPath);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<Camera.CameraDescription> cameras;
  Camera.CameraController cameraController;
  bool cameraReady = false;
  int currentCam = 0;
  Color captureColor = Colors.white;
  double borderwidth = 30.0;
  bool isRecording = false;
  String saveVideoPath;
  List<String> recentlyRecordedVideo = [];
  bool recordingCompleted = false;
  @override
  void initState() {
    super.initState();
    initCameras();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initCameras() async {
    if (!cameraReady) {
      await getCameras();
      cameraReady = true;
    }
    cameraController = Camera.CameraController(
        cameras[currentCam], Camera.ResolutionPreset.medium);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> getCameras() async {
    cameras = await Camera.availableCameras();
  }

  String getNewVideoFileName() {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '${widget.baseVideoPath}MAVE$timestamp.mp4';
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController != null && cameraController.value.isInitialized) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: NativeOrientation.NativeDeviceOrientationReader(
                builder: (BuildContext context) {
                  return rotatedCameraPreviewWidget(context);
                },
              ),
            ),
          ),
          AlignPositioned(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isRecording = !isRecording;
                    if (isRecording) {
                      borderwidth = 5.0;
                      captureColor = Colors.red;
                    } else {
                      borderwidth = 30.0;
                      captureColor = Colors.white;
                    }
                  });
                  if (cameraController.value.isRecordingVideo) {
                    cameraController.stopVideoRecording();
                  } else {
                    String temp = getNewVideoFileName();
                    temp = getNewVideoFileName();
                    recentlyRecordedVideo.add(temp);
                    cameraController.startVideoRecording(temp);
                  }
                },
                child: AnimatedContainer(
                  curve: Curves.bounceOut,
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(35.0),
                    border: Border.all(
                      color: captureColor,
                      width: borderwidth,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AlignPositioned(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0, bottom: 10.0),
              child: GestureDetector(
                onTap: () async {
                  if (cameraController.value.isRecordingVideo) {
                    await cameraController.stopVideoRecording();
                  }
                  if (currentCam == 0) {
                    currentCam = 1;
                  } else {
                    currentCam = 0;
                  }
                  initCameras();
                },
                child: Container(
                  child: Icon(
                    currentCam == 0 ? Icons.camera_front : Icons.camera_rear,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          AlignPositioned(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
              child: GestureDetector(
                onTap: () async {
                  if (cameraController.value.isRecordingVideo) {
                    await cameraController.stopVideoRecording();
                  }
                  Navigator.of(context).pop(recentlyRecordedVideo);
                },
                child: Container(
                  child: Icon(
                    Icons.keyboard_backspace,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget rotatedCameraPreviewWidget(BuildContext context) {
    Widget cameraPreview = Container();
    switch (
        NativeOrientation.NativeDeviceOrientationReader.orientation(context)) {
      case NativeOrientation.NativeDeviceOrientation.portraitUp:
        cameraPreview = Camera.CameraPreview(cameraController);
        break;
      case NativeOrientation.NativeDeviceOrientation.portraitDown:
        cameraPreview = RotatedBox(
          quarterTurns: 2,
          child: Camera.CameraPreview(cameraController),
        );
        break;
      case NativeOrientation.NativeDeviceOrientation.landscapeLeft:
        cameraPreview = RotatedBox(
          quarterTurns: 3,
          child: Camera.CameraPreview(cameraController),
        );
        break;
      case NativeOrientation.NativeDeviceOrientation.landscapeRight:
        cameraPreview = RotatedBox(
          quarterTurns: 1,
          child: Camera.CameraPreview(cameraController),
        );
        break;
      default:
        cameraPreview = Camera.CameraPreview(cameraController);
    }
    return cameraPreview;
  }
}
