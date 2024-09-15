import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note/content/Searching%20Note%20Empty.dart';
import 'package:note/content/addnote.dart';
import 'package:note/content/editnote.dart';
import 'package:note/signInUp/SignIn_.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 56, 54, 54),
        shape: StadiumBorder(),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Addnote()),
              (Route) => false);
        },
        child: Icon(Icons.add, color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Note",
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeSearchingnoteempty()));
              },
              icon: Icon(Icons.search),
              color: Colors.white),
          IconButton(
              onPressed: () {
                GoogleSignIn? googleUser = GoogleSignIn();
                googleUser.disconnect();
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => homepage2()),
                    (route) => false);
              },
              icon: Icon(Icons.logout),
              color: Colors.white),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('note')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("image/rafiki.png", height: 250),
                    Text("Create your first note!",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 1.5,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  Editnote(
                                  id: doc.id,
                                  title: doc['title'],
                                  content: doc['content'],
                                  color: Color(int.parse(doc['color'])),
                                  image: doc['image'],

                                )));
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                  
                ),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        FirebaseFirestore.instance
                            .collection('note')
                            .doc(doc.id)
                            .delete();
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                  
                ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Card(
                    color: doc['color'] != "4278190080"
                        ? Color(int.parse(doc['color']))
                        : const Color.fromARGB(255, 18, 178, 175),
                    child: Container(
                      width: 400,
                      child: Column(
                        children: [
                          Text(
                            doc['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            doc['content'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
