import 'dart:math';

import 'package:flutter/material.dart';

import 'package:webrtc_interface/webrtc_interface.dart';

// import 'rtc_video_renderer_impl.dart';

class ClientVideoView extends StatelessWidget {
  ClientVideoView(
    this._renderer, {
    Key? key,
    // this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirror = false,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  }) : super(key: key);

  final _renderer;
  final bool mirror;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  // RTCVideoRenderer get videoRenderer => _renderer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            _buildVideoView(context, constraints));
  }

  Widget _buildVideoView(BuildContext context, BoxConstraints constraints) {
    return Center(
        child: Container(
      color: Colors.red,
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Center(
          child: Column(
        children: [
          // Image.memory(bytes),
          Texture(
            textureId: 879878978789787897,
            filterQuality: filterQuality,
          ),
        ],
      )),
    ));
  }
}
