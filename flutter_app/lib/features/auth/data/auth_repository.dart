import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../domain/user_model.dart';
import '../../../core/api_client.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? '206118713263-fiki5p4ot7nttngqs42eci1ljeoaftg9.apps.googleusercontent.com' : null,
  );

  Future<UserModel> signInWithGoogle() async {
    if (kIsWeb) {
      return await _signInWithGoogleWeb();
    } else {
      return await _signInWithGoogleAndroid();
    }
  }

  // Web uses Firebase's built-in popup flow
  Future<UserModel> _signInWithGoogleWeb() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    final UserCredential userCredential =
        await _firebaseAuth.signInWithPopup(googleProvider);

    final firebaseUser = userCredential.user!;

    final String? idToken = await firebaseUser.getIdToken();
    if (idToken != null) ApiClient.setAuthToken(idToken);

    await _registerUserInBackend(firebaseUser);

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  // Android uses GoogleSignIn package flow
  Future<UserModel> _signInWithGoogleAndroid() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Sign-in cancelled');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final firebaseUser = userCredential.user!;

    final String? idToken = await firebaseUser.getIdToken();
    if (idToken != null) ApiClient.setAuthToken(idToken);

    await _registerUserInBackend(firebaseUser);

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  Future<void> _registerUserInBackend(User user) async {
    try {
      await ApiClient.instance.post(
        '/auth/register-user',
        data: {
          'uid': user.uid,
          'email': user.email,
          'display_name': user.displayName,
          'photo_url': user.photoURL,
        },
      );
    } catch (e) {
      print('[AUTH] Backend registration error: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    ApiClient.clearAuthToken();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}