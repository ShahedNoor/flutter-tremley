// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:instant_customer_app/helpers/loading_helper.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class SocialAuthHelper {
//   static final _auth = FirebaseAuth.instance;
//   static final _googleSignIn = GoogleSignIn();

//   /// Common success handler
//   static Future<void> _handleLoginSuccess({
//     required User? user,
//     required String token,
//     required Future<void> Function(User user, String token)? onSuccess,
//   }) async {
//     if (user == null) return;

//     debugPrint("✅ Login Success");
//     debugPrint("👤 Name: ${user.displayName}");
//     debugPrint("📧 Email: ${user.email}");
//     debugPrint("🆔 UID: ${user.uid}");

//     if (onSuccess != null) await onSuccess(user, token);
//   }

//   /// Apple Sign-In
//   static Future<UserCredential?> signInWithApple({
//     //required BuildContext context,
//     required Future<void> Function(User user, String token)? onSuccess,
//   }) async {
//     try {
//       final apple = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName
//         ],
//       );

//       final credential = OAuthProvider("apple.com").credential(
//         idToken: apple.identityToken,
//         accessToken: apple.authorizationCode,
//       );

//       final userCredential = await _auth
//           .signInWithCredential(credential)
//           .waitingForFutureWithoutBg();
//       log("UserCredential: $userCredential");
//       await _handleLoginSuccess(
//         user: userCredential.user,
//         token: apple.identityToken ?? '',
//         onSuccess: onSuccess,
//       );

//       return userCredential;
//     } catch (e) {
//       debugPrint("❌ Apple Sign-In Error: $e");
//       return null;
//     }
//   }

//   /// Google Sign-In
//   static Future<UserCredential?> signInWithGoogle({
//     required Future<void> Function(User user, String token)? onSuccess,
//   }) async {
//     try {
//       await _googleSignIn.signOut();
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final auth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: auth.accessToken,
//         idToken: auth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       await _handleLoginSuccess(
//         user: userCredential.user,
//         token: auth.accessToken ?? '',
//         onSuccess: onSuccess,
//       );

//       return userCredential;
//     } catch (e) {
//       debugPrint("❌ Google Sign-In Error: $e");
//       return null;
//     }
//   }
// }
