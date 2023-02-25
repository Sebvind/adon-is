import '../flutter_flow/flutter_flow_swipeable_stack.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'discover_swipe_model.dart';
export 'discover_swipe_model.dart';

class DiscoverSwipeWidget extends StatefulWidget {
  const DiscoverSwipeWidget({Key? key}) : super(key: key);

  @override
  _DiscoverSwipeWidgetState createState() => _DiscoverSwipeWidgetState();
}

class _DiscoverSwipeWidgetState extends State<DiscoverSwipeWidget> {
  late DiscoverSwipeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DiscoverSwipeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        color: FlutterFlowTheme.of(context).primaryColor,
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
    );
  }
}
