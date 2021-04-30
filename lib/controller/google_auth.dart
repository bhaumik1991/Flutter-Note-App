import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/page/homepage.dart';
import 'package:flutter_firestore/page/loginpage.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<bool> signInWithGoogle(BuildContext context) async {
  try{
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      final UserCredential authResult = await auth.signInWithCredential(credential);

      final User user = authResult.user;

      var userData = {
        "name" : googleSignInAccount.displayName,
        "provider" : "google",
        "photoUrl" : googleSignInAccount.photoUrl,
        "email" : googleSignInAccount.email
      };

      users.doc(user.uid).get().then((doc) {
        if(doc.exists){
          doc.reference.update(userData);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }else{
          users.doc(user.uid).set(userData);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    }
  }catch(PlatformException){
    print(PlatformException);
    print("Sign in not successful");
  }
}

Future<bool> logOut(BuildContext context) async{
  await googleSignIn.disconnect();
  FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}