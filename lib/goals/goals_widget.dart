import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_swipeable_stack.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'goals_model.dart';
export 'goals_model.dart';

class GoalsWidget extends StatefulWidget {
  const GoalsWidget({Key? key}) : super(key: key);

  @override
  _GoalsWidgetState createState() => _GoalsWidgetState();
}

class _GoalsWidgetState extends State<GoalsWidget>
    with TickerProviderStateMixin {
  late GoalsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoalsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
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
          'Discover',
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: 'Maitree',
                color: FlutterFlowTheme.of(context).primaryBtnText,
                useGoogleFonts: false,
              ),
        ),
        actions: [],
        centerTitle: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FlutterFlowSwipeableStack(
                    topCardHeightFraction: 0.72,
                    middleCardHeightFraction: 0.68,
                    bottomCardHeightFraction: 0.75,
                    topCardWidthFraction: 0.9,
                    middleCardWidthFraction: 0.85,
                    bottomCardWidthFraction: 0.8,
                    onSwipeFn: (index) {},
                    onLeftSwipe: (index) {},
                    onRightSwipe: (index) {},
                    onUpSwipe: (index) {},
                    onDownSwipe: (index) {},
                    itemBuilder: (context, index) {
                      return [
                        () => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                        () => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFF7C5B25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                        () => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFF5C4217),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                      ][index]();
                    },
                    itemCount: 3,
                    controller: _model.swipeableStackController,
                    enableSwipeUp: false,
                    enableSwipeDown: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
