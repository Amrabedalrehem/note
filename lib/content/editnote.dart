import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:image_picker/image_picker.dart';
import 'package:note/content/Home%20Screen.dart';

class Editnote extends StatefulWidget {
  final String title;
  final String content;
  final Color color;
  final String image;
  final String id;
  //required 

  const Editnote({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    required this.image,
    required this.id,
  });

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  @override
  void initState() {
    super.initState();
    Title.text = widget.title;
    Content.text = widget.content;
    selectedColor = widget.color;
    url1 = widget.image;
  }
  //intialization of variables

  GlobalKey<FormState> Key_ = GlobalKey();
  TextEditingController Title = TextEditingController();
  TextEditingController Content = TextEditingController();
  bool loading = false;
  CollectionReference note = FirebaseFirestore.instance.collection('note');
  Color selectedColor = Colors.black; // Default color
  File? file;
  String? url1;

  Future  UpdateUser(BuildContext context) async {
    try {
      DocumentSnapshot noteSnapshot = await note.doc(widget.id).get();
      if (noteSnapshot.exists) {
        await note.doc(widget.id).update({
          'title': Title.text,
          "content": Content.text,
          "color": selectedColor.value.toString(), // Save color as hex value
          "image": url1 ?? "",
          "savedone": true,
          'id': widget.id,
        });
       
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success Saving',
          desc: 'Your changes saved successfully',
        ).show();
            Navigator.pop(context);
      } else {
        print("Note with ID ${widget.id} does not exist");
      }
    } catch (e) {
      print("Error updating note: $e");
    }
  }

  Future<void> getphoto() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file = File(photo.path);
      var imagename = basename(photo.path);
      final storageRef = FirebaseStorage.instance.ref("$imagename");
      await storageRef.putFile(file!);
      url1 = await storageRef.getDownloadURL();
      setState(() {});
    }
  }

  @override
  void dispose() {
    Title.dispose();
    Content.dispose();
    super.dispose();
  }

  bool goto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: selectedColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 100, color: Colors.white),
            Text("Can Edit image", style: TextStyle(color: Colors.white, fontSize: 25)),
            IconButton(
              onPressed: getphoto,
              icon: Icon(Icons.add),
              color: Colors.white,
            )
          ],
        ),
      ),
      backgroundColor: selectedColor, // Set background color
      appBar: AppBar(
        backgroundColor: selectedColor,
        
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color; // Update the selected color
                          });
                        },
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.color_lens,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Save',
                desc: 'Click on save to save your changes',
                btnCancelOnPress: () {
                  Navigator.of(context).pop();
                },
                btnOkText: 'Save',
                btnCancelText: 'Discard',
                btnOkOnPress: () {
                  UpdateUser(context);
                 
                },
              ).show();
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Form(
        key: Key_,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            TextField(
              controller: Title,
              style: TextStyle(color: Colors.white, fontSize: 26),
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 26),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
                   if (url1 != null && url1 != "") Card(child: Image.network(url1!)),
            TextField(
              controller: Content,
              style: TextStyle(color: Colors.white, fontSize: 20),
              maxLines: 100,
              decoration: InputDecoration(
                hintText: "Type something...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
