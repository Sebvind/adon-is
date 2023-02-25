import '../backend/cloud_functions/cloud_functions.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_mux_broadcast.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'webinaractivefull_model.dart';
export 'webinaractivefull_model.dart';

class WebinaractivefullWidget extends StatefulWidget {
  const WebinaractivefullWidget({Key? key}) : super(key: key);

  @override
  _WebinaractivefullWidgetState createState() =>
      _WebinaractivefullWidgetState();
}

class _WebinaractivefullWidgetState extends State<WebinaractivefullWidget> {
  late WebinaractivefullModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String? muxBroadcastPlaybackUrl;
  bool muxBroadcastIsLive = false;
  LiveStreamController? muxBroadcastController;
  final _initialAudioConfig = AudioConfig(
    channel: Channel.stereo,
  );
  final _initialVideoConfig = VideoConfig.withDefaultBitrate(
    resolution: Resolution.RESOLUTION_720,
  );
  bool _isSupportedPlatform = false;
  // variables for managing camera states
  bool _isCameraInitialized = false;
  bool _isFrontCamSelected = false;
  final _stopwatch = Stopwatch();
  String? _durationString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebinaractivefullModel());

    if (Platform.isAndroid || Platform.isIOS) {
      _isSupportedPlatform = true;
      _initCamera();
    }
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    _stopwatch.stop();
    _timer?.cancel();
    Wakelock.disable();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Color(0xFF0D0D0D),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.keyboard_arrow_left_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Live',
          style: FlutterFlowTheme.of(context).title2.override(
                fontFamily: 'Maitree',
                color: Colors.white,
                fontSize: 22,
                useGoogleFonts: false,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: FlutterFlowMuxBroadcast(
                  isCameraInitialized: _isCameraInitialized,
                  isStreaming: muxBroadcastIsLive,
                  durationString: _durationString,
                  borderRadius: BorderRadius.circular(0),
                  controller: muxBroadcastController,
                  videoConfig: _initialVideoConfig,
                  onCameraRotateButtonTap: () async {
                    await switchCamera();
                    setState(() => _isFrontCamSelected = !_isFrontCamSelected);
                  },
                  startButtonText: 'Start Stream',
                  startButtonIcon: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  startButtonOptions: FFButtonOptions(
                    width: 160,
                    height: 50,
                    color: FlutterFlowTheme.of(context).primaryColor,
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Maitree',
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  liveIcon: FaIcon(
                    FontAwesomeIcons.solidCircle,
                    color: Colors.red,
                    size: 10,
                  ),
                  liveText: 'Live',
                  liveTextStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Maitree',
                            color: Colors.red,
                            useGoogleFonts: false,
                          ),
                  liveTextBackgroundColor: Color(0x8A000000),
                  durationTextStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Maitree',
                            color: Colors.red,
                            useGoogleFonts: false,
                          ),
                  durationTextBackgroundColor: Color(0x8A000000),
                  liveContainerBorderRadius: BorderRadius.circular(8),
                  durationContainerBorderRadius: BorderRadius.circular(8),
                  rotateButtonColor: Color(0x8A000000),
                  rotateButtonIcon: Icon(
                    Icons.flip_camera_android,
                    color: Colors.white,
                    size: 24,
                  ),
                  stopButtonIcon: Icon(
                    Icons.stop_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  stopButtonColor: Colors.red,
                  onStartButtonTap: () async {
                    await startStreaming();
                  },
                  onStopButtonTap: () async {
                    stopStreaming();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _initCamera() async {
    muxBroadcastController = initLiveStreamController();
    await muxBroadcastController!.create(
      initialAudioConfig: _initialAudioConfig,
      initialVideoConfig: _initialVideoConfig,
    );
    setState(() => _isCameraInitialized = true);
  }

  LiveStreamController initLiveStreamController() {
    return LiveStreamController(
      onConnectionSuccess: () {
        print('Connection succeeded');
        setState(() => muxBroadcastIsLive = true);
        _startTimer();
      },
      onConnectionFailed: (error) {
        print('Connection failed: $error');
        if (mounted) setState(() {});
      },
      onDisconnection: () {
        print('Disconnected');
        if (mounted) setState(() => muxBroadcastIsLive = false);
        _stopTimer();
      },
    );
  }

  Future<void> switchCamera() async {
    final LiveStreamController? liveStreamController = muxBroadcastController;
    if (liveStreamController == null) return;
    try {
      liveStreamController.switchCamera();
    } catch (error) {
      if (error is PlatformException) {
        print('Failed to switch camera: ${error.message}');
      } else {
        print('Failed to switch camera: $error');
      }
    }
  }

  Future<void> startStreaming() async {
    final LiveStreamController? liveStreamController = muxBroadcastController;
    if (liveStreamController == null) return;
    const streamBaseURL = 'rtmps://global-live.mux.com:443/app/';
    final callName = 'createLiveStream';
    final response = await makeCloudCall(callName, {});
    final streamKey = response['stream_key'];
    final playbackId = response['playback_ids'][0]['id'];
    muxBroadcastPlaybackUrl = 'https://stream.mux.com/$playbackId.m3u8';
    if (streamKey != null) {
      try {
        Wakelock.enable();
        await liveStreamController.startStreaming(
          streamKey: streamKey,
          url: streamBaseURL,
        );
      } catch (error) {
        if (error is PlatformException) {
          print("Error: failed to start stream: ${error.message}");
        } else {
          print("Error: failed to start stream: $error");
        }
      }
    }
  }

  Future<void> stopStreaming() async {
    final LiveStreamController? liveStreamController = muxBroadcastController;
    if (liveStreamController == null) return;
    try {
      Wakelock.disable();
      liveStreamController.stopStreaming();
      if (mounted) setState(() => muxBroadcastIsLive = false);
      _stopTimer();
    } catch (error) {
      if (error is PlatformException) {
        print('Failed to stop stream: ${error.message}');
      } else {
        print('Failed to stop stream: $error');
      }
    }
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _durationString = _getDurationString(_stopwatch.elapsed);
        });
      }
    });
  }

  void _stopTimer() {
    _stopwatch
      ..stop()
      ..reset();
    _durationString = _getDurationString(_stopwatch.elapsed);
    _timer?.cancel();
  }

  String _getDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
