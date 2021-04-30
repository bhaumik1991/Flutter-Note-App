import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore/controller/google_auth.dart';
import 'package:flutter_firestore/page/add_note.dart';
import 'package:flutter_firestore/page/view_note.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CollectionReference reference = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notes');

  List<Color> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            "Notes",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          TextButton(
            child: Text(
                "Logout",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            onPressed: (){
              logOut(context);
            },
          )
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: reference.get(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  Random random = Random();
                  Color bg = myColors[random.nextInt(4)];
                  Map data = snapshot.data.docs[index].data();
                  DateTime myDateTime = data['created'].toDate();
                  String formattedTime = DateFormat.yMMMd().add_jm().format(myDateTime);
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewNote(
                            data,
                            formattedTime,
                            snapshot.data.docs[index].reference)),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Card(
                      color: bg,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${data["title"]}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  DateFormat.yMMMd().add_jm().format(myDateTime),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }else{
            return Center(
              child: Text("Loading"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AddNote(),
            ),
          ).then((value) {
            print("Calling set state");
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
