import 'package:flutter/material.dart';
import 'package:flutter_firestore/controller/google_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Note App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Create and manage your notes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  signInWithGoogle(context);
                },
                child: Text(
                    "Continue with Google",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
