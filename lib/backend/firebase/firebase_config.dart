import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCkESdXt3IEpDg8on2Df73cuwZ8x2D6a1g",
            authDomain: "adon-is.firebaseapp.com",
            projectId: "adon-is",
            storageBucket: "adon-is.appspot.com",
            messagingSenderId: "360095697104",
            appId: "1:360095697104:web:b976ffbee6b7fcde0ab6d5",
            measurementId: "G-SGLJPCBTFP"));
  } else {
    await Firebase.initializeApp();
  }
}
