import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../auth/domain/user_model.dart';
import '../../../core/api_client.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google → get Firebase token → register with backend
  Future<UserModel> signInWithGoogle() async {
    // Step 1: Google Sign-In popup/flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Sign-in cancelled');

    // Step 2: Get auth credentials
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Step 3: Sign into Firebase
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final firebaseUser = userCredential.user!;

    // Step 4: Get Firebase ID token for backend
    final String idToken = await firebaseUser.getIdToken() ?? '';

    // Step 5: Attach token to API client
    ApiClient.setAuthToken(idToken);

    // Step 6: Register/update user in our backend
    await _registerUserInBackend(firebaseUser, idToken);

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
    );
  }

  Future<void> _registerUserInBackend(User user, String idToken) async {
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
      // Non-critical — user is still logged in locally
      print('Backend registration error: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    ApiClient.clearAuthToken();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}