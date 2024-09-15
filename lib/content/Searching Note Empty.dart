import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note/content/Searching%20Note%20Empty.dart';
import 'package:note/content/addnote.dart';
import 'package:note/content/editnote.dart';
import 'package:note/signInUp/SignIn_.dart';

class HomeSearchingnoteempty extends StatefulWidget {
  @override
  State<HomeSearchingnoteempty> createState() => _HomeSearchingnoteempty();
}

class _HomeSearchingnoteempty extends State<HomeSearchingnoteempty> {
  TextEditingController controller_search = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: controller_search,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    controller_search.clear();
                    setState(() {
                      searchText = "";
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  searchText = text;
                });
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  searchText = controller_search.text;
                 });
              },
              icon: Icon(Icons.search, color: Colors.white, size: 100),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('title', isEqualTo: searchText)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("image/cuate.png", height: 160),
                    Text("note is not found try again",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ),
            );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Editnote(
                                      color: Color(int.parse(doc['color'])),
                                      image: doc['image'],
                                      id: doc.id,
                                      title: doc['title'],
                                      content: doc['content'],
                                    ),
                                  ),
                                );
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.green,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                FirebaseFirestore.instance
                                    .collection('notes')
                                    .doc(doc.id)
                                    .delete();
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    doc['content'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
