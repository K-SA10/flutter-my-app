import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

Future<Null> ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
    await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}

Future<Null> testSignInWithGoogle() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  print("signInWithGoogle succeeded: $user");

//  return 'signInWithGoogle succeeded: $user';
}