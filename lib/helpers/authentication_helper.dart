import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await _googleUser.authentication;
    final AuthCredential _credential = GoogleAuthProvider.getCredential(
        accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);
    return (await _firebaseAuth.signInWithCredential(_credential)).user;
  }

  Future<FirebaseUser> currentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    if (_googleSignIn != null) _googleSignIn.signOut();
  }
}
