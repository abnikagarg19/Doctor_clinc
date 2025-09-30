import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  final bool smallView; 

  const ParticipantTile({
    super.key,
    required this.participant,
    this.smallView = false, 
  });

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;

  @override
  void initState() {
    super.initState();
    // widget.participant.streams.forEach((key, Stream stream) {
    //   if (stream.kind == 'video') {
    //     setState(() {
    //       videoStream = stream;
    //     });
    //   }
    // });
    _initStreamListeners();
  }

  void _initStreamListeners() {
    widget.participant.unmuteMic();
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.smallView ? 120 : double.infinity, 
      height: widget.smallView ? 100 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: videoStream != null
          ? RTCVideoView(mirror: true,filterQuality: FilterQuality.high,
              videoStream?.renderer as RTCVideoRenderer,

              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          : const Center(
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
    );
  }
}
