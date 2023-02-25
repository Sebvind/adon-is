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
import 'webinaractive_model.dart';
export 'webinaractive_model.dart';

class WebinaractiveWidget extends StatefulWidget {
  const WebinaractiveWidget({Key? key}) : super(key: key);

  @override
  _WebinaractiveWidgetState createState() => _WebinaractiveWidgetState();
}

class _WebinaractiveWidgetState extends State<WebinaractiveWidget> {
  late WebinaractiveModel _model;

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
    _model = createModel(context, () => WebinaractiveModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 12),
                child: Container(
                  width: double.infinity,
                  height: 619,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      FlutterFlowMuxBroadcast(
                        isCameraInitialized: _isCameraInitialized,
                        isStreaming: muxBroadcastIsLive,
                        durationString: _durationString,
                        borderRadius: BorderRadius.circular(15),
                        controller: muxBroadcastController,
                        videoConfig: _initialVideoConfig,
                        onCameraRotateButtonTap: () async {
                          await switchCamera();
                          setState(
                              () => _isFrontCamSelected = !_isFrontCamSelected);
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
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Maitree',
                                    color: Colors.white,
                                    useGoogleFonts: false,
                                  ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).tertiary,
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
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(12, 470, 12, 80),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    'https://picsum.photos/seed/6/600',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0, 0.22),
                                      child: Text(
                                        'Life Coach & Entrepreneur ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'JejuMyeongjo',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .dark900,
                                              fontSize: 12.5,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, -0.3),
                                      child: Text(
                                        'Hamza Ahmed',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText1
                                            .override(
                                              fontFamily: 'JejuMyeongjo',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryColor,
                                              fontSize: 18,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(20, 550, 12, 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 50,
                              child: VerticalDivider(
                                thickness: 1,
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment:
                                        AlignmentDirectional(-0.92, 0.84),
                                    child: Text(
                                      '2:30am - 2:40am',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'JejuMyeongjo',
                                            color: FlutterFlowTheme.of(context)
                                                .dark900,
                                            fontSize: 14,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0, -0.73),
                                    child: Text(
                                      'My experience with\ndepression & how i beat it',
                                      style: FlutterFlowTheme.of(context)
                                          .title1
                                          .override(
                                            fontFamily: 'Maitree',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                            lineHeight: 1.1,
                                          ),
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
