import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_database/firebase_database.dart';

class WebRTCService {
  RTCPeerConnection? _pc;
  MediaStream? localStream;
  final remoteRenderer = RTCVideoRenderer();

  bool micOn = true;
  bool camOn = true;
  bool speakerOn = true;
  bool isVideoCall = false;

  final db = FirebaseDatabase.instance.ref();

  // ================= INIT =================
  Future<void> init(bool video) async {
    isVideoCall = video;

    await remoteRenderer.initialize();

    final mediaConstraints = {
      'audio': true,
      'video': video
          ? {'facingMode': 'user'}
          : false,
    };

    localStream =
    await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  // ================= PEER CONNECTION =================
  Future<RTCPeerConnection> _createPC(
      String roomId, bool isCaller) async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };

    final pc = await createPeerConnection(config);

    localStream!.getTracks().forEach((track) {
      pc.addTrack(track, localStream!);
    });

    pc.onIceCandidate = (candidate) {
      final path = isCaller
          ? 'rooms/$roomId/callerCandidates'
          : 'rooms/$roomId/calleeCandidates';

      db.child(path).push().set(candidate.toMap());
    };

    pc.onTrack = (event) {
      remoteRenderer.srcObject = event.streams.first;
    };

    return pc;
  }

  // ================= CALLER =================
  Future<String> startCall(
      String myId, String peerId, bool video) async {
    await init(video);

    final roomRef = db.child('rooms').push();
    final roomId = roomRef.key!;

    _pc = await _createPC(roomId, true);

    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);

    await roomRef.child('offer').set(offer.toMap());

    await db.child('calls/$peerId').set({
      'from': myId,
      'roomId': roomId,
      'video': video,
    });

    roomRef.child('answer').onValue.listen((event) async {
      if (event.snapshot.value == null) return;
      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map);
      await _pc!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type']),
      );
    });

    roomRef.child('calleeCandidates').onChildAdded.listen((event) {
      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map);
      _pc!.addCandidate(
        RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ),
      );
    });

    return roomId;
  }

  // ================= RECEIVER =================
  Future<void> acceptCall(String roomId, bool video) async {
    await init(video);

    final roomRef = db.child('rooms/$roomId');

    _pc = await _createPC(roomId, false);

    final offerSnap = await roomRef.child('offer').get();
    final offer =
    Map<String, dynamic>.from(offerSnap.value as Map);

    await _pc!.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );

    final answer = await _pc!.createAnswer();
    await _pc!.setLocalDescription(answer);

    await roomRef.child('answer').set(answer.toMap());

    roomRef.child('callerCandidates').onChildAdded.listen((event) {
      final data =
      Map<String, dynamic>.from(event.snapshot.value as Map);
      _pc!.addCandidate(
        RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        ),
      );
    });
  }

  // ================= CONTROLS =================
  void toggleMic() {
    micOn = !micOn;
    localStream?.getAudioTracks().first.enabled = micOn;
  }

  void toggleCamera() {
    if (!isVideoCall) return;
    if (localStream == null) return;
    if (localStream!.getVideoTracks().isEmpty) return;

    camOn = !camOn;
    localStream!.getVideoTracks().first.enabled = camOn;
  }

  void switchCamera() {
    if (!isVideoCall) return;
    Helper.switchCamera(localStream!.getVideoTracks().first);
  }

  void toggleSpeaker() {
    speakerOn = !speakerOn;
    Helper.setSpeakerphoneOn(speakerOn);
  }

  Future<void> hangUp(String myId) async {
    await _pc?.close();
    await localStream?.dispose();
    await remoteRenderer.dispose();
    await db.child('calls/$myId').remove();
  }
}
