import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note/content/Searching%20Note%20Empty.dart';
import 'package:note/content/addnote.dart';
import 'package:note/content/editnote.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _HomepageState();
}

class _HomepageState extends State<homepage> {
  Future<List<DocumentSnapshot>> _getNotes() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('note')
        .where('id', isEqualTo: uid)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 56, 54, 54),
        shape: const StadiumBorder(),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Addnote()),
              (Route) => false);
        },
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Note",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>   HomeSearchingnoteempty()));
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              GoogleSignIn? googleUser = GoogleSignIn();
              googleUser.disconnect();
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) =>   homepage()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _getNotes(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("image/rafiki.png", height: 250),
                    const Text("Create your first note!",
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
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data![index];
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
                  motion: const ScrollMotion(),
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
                  margin: const EdgeInsets.all(20),
                  child: Card(
                    color: doc['color'] != "4278190080"
                        ? Color(int.parse(doc['color']))
                        : const Color.fromARGB(255, 18, 178, 175),
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          Text(
                            doc['title'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            doc['content'],
                            style: const TextStyle(
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
