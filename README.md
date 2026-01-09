# 🖥️ WebRTCAudio/VideoCall 

A simple Flutter WebRTC app for making audio and video calls between users using Firebase Realtime Database for signaling.

## 📌 Features

* ✅ One-to-one video and audio calls
* ✅ Toggle microphone, camera, and speaker
* ✅ Switch between front and back camera
* ✅ Real-time call notifications via Firebase
* ✅ Supports caller and callee flows
* ✅ Full screen remote video with small local preview

---
## ✨ Preview
<img src="https://github.com/user-attachments/assets/810aa40c-f2b1-4337-bc53-2383c5474b3d" width="400"/>
<img src="https://github.com/user-attachments/assets/d584c04c-ffb2-4bdb-adb5-1380b7ee3707" width="400"/>

---
## 📂 Folder Structure
```
lib/
│
├── main.dart                # App entry point
├── screens/
│   ├── home_screen.dart     # Displays user ID and start call UI
│   └── call_screen.dart     # Video/Audio call UI
│
└── services/
    └── webrtc_service.dart # WebRTC logic, peer connection, Firebase signaling
```
---
## Set up Firebase:
* Go to Firebase Console
* Create a new project
* Add Android/iOS app to the project
* Download google-services.json for Android or GoogleService-Info.plist for iOS
* Place them in the correct folder (android/app/ or ios/Runner/)

## Enable Realtime Database:
* Go to Realtime Database → Create database
Set rules to:
```
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```
---
## 🏗️ How It Works
### HomeScreen
* Displays your User ID
* Lets you start a call by entering the receiver's user ID
* Listens for incoming calls via Firebase
  
### CallScreen
* Handles the WebRTC connection
* Shows remote video full-screen and local video preview
* Controls: mic, camera, switch camera, speaker, hang up
* Caller initiates the call, callee accepts via listener

### WebRTCService
* Handles local/remote streams, peer connection, and Firebase signaling
* Supports:
 * Audio/video toggle
 * Camera switch
 * Speaker toggle
 * Hang up
* Uses Firebase Realtime Database for signaling (rooms, calls, callerCandidates, calleeCandidates)
---
## 🔧 Usage
* Open the app on two devices or emulators.
* Copy your User ID from HomeScreen.
* Enter the other device's User ID and press Start Video Call.
* The other device will receive a call notification and join the call automatically.
* Use buttons to toggle mic, camera, speaker, or switch camera.
* Press hang up to end the call.
---
## 🛠️ Dependencies
```
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_database: ^10.0.0
  flutter_webrtc: ^0.9.21
```
---
## ⚡ Notes
* This app uses Firebase Realtime Database for signaling. No TURN server is included, so it may not work in all networks for remote devices.
* Random user IDs are generated on app start. Use permanent IDs for production.
* The app currently supports one-to-one calls. Group calls require extra implementation.
---
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
---
