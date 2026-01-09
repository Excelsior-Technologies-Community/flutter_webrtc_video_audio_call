// import 'package:flutter/material.dart';
// import '../services/webrtc_service.dart';
//
// class WhatsAppCallControls extends StatefulWidget {
//   final WebRTCService webrtc;
//   final VoidCallback onEnd;
//
//   const WhatsAppCallControls({
//     super.key,
//     required this.webrtc,
//     required this.onEnd,
//   });
//
//   @override
//   State<WhatsAppCallControls> createState() => _WhatsAppCallControlsState();
// }
//
// class _WhatsAppCallControlsState extends State<WhatsAppCallControls> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       color: Colors.black87,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _btn(
//             widget.webrtc.micOn ? Icons.mic : Icons.mic_off,
//             widget.webrtc.toggleMic,
//           ),
//
//           if (widget.webrtc.isVideoCall)
//             _btn(
//               widget.webrtc.camOn
//                   ? Icons.videocam
//                   : Icons.videocam_off,
//               widget.webrtc.toggleCamera,
//             ),
//
//           if (widget.webrtc.isVideoCall)
//             _btn(Icons.cameraswitch, widget.webrtc.switchCamera),
//
//           _btn(
//             widget.webrtc.speakerOn
//                 ? Icons.volume_up
//                 : Icons.hearing,
//             widget.webrtc.toggleSpeaker,
//           ),
//
//           CircleAvatar(
//             backgroundColor: Colors.red,
//             radius: 28,
//             child: IconButton(
//               icon: const Icon(Icons.call_end, color: Colors.white),
//               onPressed: widget.onEnd,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _btn(IconData icon, VoidCallback onTap) {
//     return CircleAvatar(
//       backgroundColor: Colors.grey.shade800,
//       radius: 26,
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: () {
//           onTap();
//           setState(() {});
//         },
//       ),
//     );
//   }
// }
