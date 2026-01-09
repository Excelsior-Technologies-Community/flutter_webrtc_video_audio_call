import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/webrtc_service.dart';

class CallScreen extends StatefulWidget {
  final String myUserId;
  final String peerUserId;
  final bool isCaller;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.myUserId,
    required this.peerUserId,
    required this.isCaller,
    required this.isVideoCall,
    required bool roomId,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final webrtc = WebRTCService();
  final localRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await localRenderer.initialize();

    if (widget.isCaller) {
      await webrtc.startCall(
        widget.myUserId,
        widget.peerUserId,
        widget.isVideoCall,
      );
    } else {
      // handled by HomeScreen listener
    }

    localRenderer.srcObject = webrtc.localStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RTCVideoView(webrtc.remoteRenderer),
          if (widget.isVideoCall)
            Positioned(
              top: 40,
              right: 20,
              width: 120,
              height: 160,
              child: RTCVideoView(localRenderer, mirror: true),
            ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(
                  webrtc.micOn ? Icons.mic : Icons.mic_off,
                  webrtc.toggleMic,
                ),
                if (widget.isVideoCall)
                  _btn(
                    webrtc.camOn ? Icons.videocam : Icons.videocam_off,
                    webrtc.toggleCamera,
                  ),
                if (widget.isVideoCall)
                  _btn(Icons.cameraswitch, webrtc.switchCamera),
                _btn(
                  webrtc.speakerOn ? Icons.volume_up : Icons.hearing,
                  webrtc.toggleSpeaker,
                ),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.white),
                    onPressed: () async {
                      await webrtc.hangUp(widget.myUserId);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade800,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {
          onTap();
          setState(() {});
        },
      ),
    );
  }
}
