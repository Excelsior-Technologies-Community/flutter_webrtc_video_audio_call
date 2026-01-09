import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'call_screen.dart';

class HomeScreen extends StatefulWidget {
  final String myUserId;

  const HomeScreen({super.key, required this.myUserId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseDatabase.instance.ref();
  bool _incomingHandled = false;

  @override
  void initState() {
    super.initState();

    /// 🔔 LISTEN FOR INCOMING CALL
    db.child('calls/${widget.myUserId}').onValue.listen((event) {
      if (!event.snapshot.exists) return;
      if (_incomingHandled) return;

      _incomingHandled = true;

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      final roomId = data['roomId'];
      final callerId = data['from'];
      final isVideo = data['video'] ?? true;

      /// remove call notification
      db.child('calls/${widget.myUserId}').remove();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            myUserId: widget.myUserId,
            peerUserId: callerId,
            isCaller: false,
            roomId: roomId,
            isVideoCall: isVideo,
          ),
        ),
      ).then((_) {
        _incomingHandled = false;
      });
    });
  }

  /// 📞 START CALL
  Future<void> _startCall() async {
    final otherUserIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Call User"),
        content: TextField(
          controller: otherUserIdController,
          decoration: const InputDecoration(hintText: "Enter receiver userId"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Video Call"),
            onPressed: () async {
              final otherUserId = otherUserIdController.text.trim();

              if (otherUserId.isEmpty || otherUserId == widget.myUserId) {
                return;
              }

              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallScreen(
                    myUserId: widget.myUserId,
                    peerUserId: otherUserId,
                    isCaller: true,
                    isVideoCall: true,
                    roomId: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebRTC Call"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My User ID", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            SelectableText(
              widget.myUserId,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.video_call),
              label: const Text("Start Video Call"),
              onPressed: _startCall,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
