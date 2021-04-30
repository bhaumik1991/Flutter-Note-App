import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_ios_outlined),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.grey
                          )
                        ),
                      ),
                      ElevatedButton(
                          onPressed: add,
                          child: Icon(Icons.save),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.red
                            )
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12.0,),
                Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration.collapsed(hintText: "Title"),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          onChanged: (val){
                            title = val;
                          },
                        ),
                        SizedBox(height: 15,),
                        Divider(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: TextFormField(
                            decoration: InputDecoration.collapsed(hintText: "Note Description"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            onChanged: (val){
                              description = val;
                            },
                            maxLines: 20,
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() async{
    CollectionReference reference = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('notes');

    var dataSet = {
      'title' : title,
      'description' : description,
      'created' : DateTime.now(),
    };

    reference.add(dataSet);

    Navigator.of(context).pop();
  }
}
