import 'package:firebase_messaging/firebase_messaging.dart';

class CMFirebase {
  final fcm = FirebaseMessaging.instance;

  // create a singleton
  static final CMFirebase _singleton = new CMFirebase._internal();
  CMFirebase._internal();

  // initialization methods
  static CMFirebase getInstance() => _singleton;
  factory CMFirebase() => _singleton;
  static CMFirebase get instance => _singleton;

  // void configureFCM() async {
  //   fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //     },
// //      onBackgroundMessage: (Map<String, dynamic> message) async {
// //        print("onBackgroundMessage: $message");
// //        await _notify(message["data"]["body"]);
// //      }
  //   );
  // }

  Future<String> getDeviceToken() async {
    String fcmToken = await fcm.getToken();

    return fcmToken;
  }
}
