import 'package:flutter/material.dart';
import 'package:mave/pages/capture.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;
import 'package:simple_permissions/simple_permissions.dart' as Permission;
import 'package:video_player/video_player.dart';

import 'dart:io';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _previousPlayer;
  VideoPlayerController _currentPlayer;
  // VideoPlayerController _nextPlayer;
  Future<void> _initializeVideoPlayerFuture;
  static const double simplePadding = 10.0;
  static const iconSize = 40.0;
  bool setPermission = false;
  int videoIndex = 0;
  List<String> videoFilesList = [];
  dynamic _positionedKey;

  @override
  void initState() {
    super.initState();
    _previousPlayer = null;
    // VideoProgressIndicator(
    //   _videoPlayerController,
    //   allowScrubbing: true,
    //   colors: VideoProgressColors(),
    // );
    // print('///////////////////////////////////////////////////////////////');
    // print('Aspect Ratio: ${_videoPlayerController.value.aspectRatio}');
    setDIRPermission();
  }

  Future<String> getBaseVideoPath() async {
    String baseDir = (await PathProvider.getExternalStorageDirectory()).path;
    bool maveExists = await Directory('$baseDir/DCIM/MaveVideos/').exists();
    if (!maveExists) {
      await Directory('$baseDir/DCIM/MaveVideos/').create(recursive: true);
    }
    return '$baseDir/DCIM/MaveVideos/';
  }

  Future<void> setDIRPermission() async {
    // this method sets the READ and WRITE permission
    // to EXTERNAL_STORAGE if not granted already for the app.
    bool success = true;
    Directory DIR = await PathProvider.getExternalStorageDirectory();
    bool canReadPermission = await Permission.SimplePermissions.checkPermission(
        Permission.Permission.ReadExternalStorage);
    bool canWritePermission =
        await Permission.SimplePermissions.checkPermission(
            Permission.Permission.WriteExternalStorage);
    if (!canReadPermission) {
      var readstatus = await Permission.SimplePermissions.requestPermission(
          Permission.Permission.ReadExternalStorage);
      if (readstatus != Permission.PermissionStatus.authorized) {
        success = false;
      }
    }
    if (!canWritePermission) {
      var writestatus = await Permission.SimplePermissions.requestPermission(
          Permission.Permission.WriteExternalStorage);
      if (writestatus != Permission.PermissionStatus.authorized) {
        success = false;
      }
    }
    if (success) {
      videoFilesList.clear();
      DIR.list(recursive: true, followLinks: false).listen((file) {
        if (file.path.endsWith('.mp4')) {
          videoFilesList.add(file.path);
          print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${file.path}');
        }
      }).onDone(() {
        nextVideo();
      });
    }
    setPermission = true;
  }

  void nextVideo() {
    if (_currentPlayer != null) {
      //current is playing
      _currentPlayer.pause();
      _previousPlayer = _currentPlayer;
      videoIndex++;
      if (videoIndex == videoFilesList.length) {
        videoIndex = 0;
      }
      _currentPlayer =
          VideoPlayerController.file(File(videoFilesList[videoIndex]));
      _currentPlayer.setVolume(1.0);
      _currentPlayer.setLooping(true);
      _initializeVideoPlayerFuture = _currentPlayer.initialize();
      _initializeVideoPlayerFuture.whenComplete(() {
        _previousPlayer.dispose();
      });
      setState(() {});
    } else {
      // currentPlayer is null
      _currentPlayer = VideoPlayerController.file(File(videoFilesList.first));
      _currentPlayer.setVolume(1.0);
      _currentPlayer.setLooping(true);
      _initializeVideoPlayerFuture = _currentPlayer.initialize();
      _initializeVideoPlayerFuture.whenComplete(() {
        if (_previousPlayer != null) {
          _previousPlayer.dispose();
        }
      });
      setState(() {});
    }
  }

  void previousVideo() {
    if (_currentPlayer != null) {
      //current is playing
      _currentPlayer.pause();
      _previousPlayer = _currentPlayer;
      videoIndex--;
      if (videoIndex < 0) {
        videoIndex = videoFilesList.length - 1;
      }
      _currentPlayer =
          VideoPlayerController.file(File(videoFilesList[videoIndex]));
      _currentPlayer.setVolume(1.0);
      _currentPlayer.setLooping(true);
      _initializeVideoPlayerFuture = _currentPlayer.initialize();
      _initializeVideoPlayerFuture.whenComplete(() {
        _previousPlayer.dispose();
      });
    } else {
      _currentPlayer = VideoPlayerController.file(File(videoFilesList.last));
      _initializeVideoPlayerFuture = _currentPlayer.initialize();
      _initializeVideoPlayerFuture.whenComplete(() {
        if (_previousPlayer != null) {
          _previousPlayer.dispose();
        }
      });
    }
  }

  @override
  void dispose() {
    _previousPlayer?.setVolume(0.0);
    _previousPlayer?.dispose();
    _currentPlayer?.setVolume(0.0);
    _currentPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.7], //stack
            colors: [
              Color(0XFF00B0E8), //blue
              Color(0XFFC2216B), //pink
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: FutureBuilder<void>(
                future: _initializeVideoPlayerFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //future is complete
                    print('VIDEODETAILS:*******************************');
                    // print(
                    //     '${_currentPlayer.value.size.width} X ${_currentPlayer.value.size.height}');
                    print('${_currentPlayer.value.aspectRatio}');
                    print('VIDEODETAILS:*******************************');
                    _currentPlayer.play();
                    return GestureDetector(
                      onTap: () {
                        nextVideo();
                      },
                      child: (_currentPlayer.value.aspectRatio <= 1)
                          ? AspectRatio(
                              aspectRatio: _currentPlayer.value.aspectRatio,
                              child: VideoPlayer(_currentPlayer),
                            )
                          : VideoPlayer(_currentPlayer),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 15.0,
                  bottom: 15.0,
                ),
                child: Column(
                  children: <Widget>[
                    //Account IconButton
                    Padding(
                      padding: const EdgeInsets.only(
                          top: simplePadding, bottom: simplePadding),
                      child: IconButton(
                        onPressed: null,
                        color: Colors.white,
                        iconSize: iconSize,
                        icon: Icon(Icons.account_circle),
                      ),
                    ),
                    //Like button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: simplePadding, bottom: simplePadding),
                      child: IconButton(
                        onPressed: null,
                        color: Colors.white,
                        iconSize: iconSize,
                        icon: Icon(Icons.thumb_up),
                      ),
                    ),
                    //comment button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: simplePadding, bottom: simplePadding),
                      child: IconButton(
                        onPressed: null,
                        color: Colors.white,
                        iconSize: iconSize,
                        icon: Icon(Icons.comment),
                      ),
                    ),
                    //Share button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: simplePadding, bottom: simplePadding),
                      child: IconButton(
                        onPressed: null,
                        color: Colors.white,
                        iconSize: iconSize,
                        icon: Icon(Icons.share),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: simplePadding, bottom: simplePadding),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                if (_currentPlayer != null) {
                                  _currentPlayer.setVolume(0.0);
                                  _currentPlayer.pause();
                                }
                                return FutureBuilder(
                                  future: getBaseVideoPath(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return CameraScreen(snapshot.data);
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ).then((dynamic videopathlist) {
                            for (String videopath in videopathlist) {
                              videoFilesList.add(videopath);
                            }
                          }).whenComplete(() {
                            if (_currentPlayer != null) {
                              _currentPlayer.setVolume(1.0);
                              _currentPlayer.play();
                            } else {
                              nextVideo();
                            }
                          });
                        },
                        color: Colors.white,
                        iconSize: iconSize,
                        icon: Icon(Icons.create),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
