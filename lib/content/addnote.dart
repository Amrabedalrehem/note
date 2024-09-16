
 import 'dart:io';
 import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/content/Home%20Screen.dart';
//لو داس ع الصوره هحذفها 
class Addnote extends StatefulWidget {
  const Addnote({super.key});

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  GlobalKey<FormState> Key_ = GlobalKey();
  TextEditingController Title = TextEditingController();
  TextEditingController Content = TextEditingController();
  bool loading = false;
  CollectionReference note = FirebaseFirestore.instance.collection('note');
  Color selectedColor = Colors.black; // Default color
   Setuser(context) async {
    if (Key_.currentState!.validate()) {
      try {
        loading = true;

        await note.doc().set({
          'title': Title.text,
          "content": Content.text,
          "color": selectedColor.value.toString() , // Save color as hex value
          "image": url1 == null ? "" : url1,
          "id": FirebaseAuth.instance.currentUser!.uid,
           "savedone":goto ,
         },);

        setState(() {});
        Navigator.pop(context);
        Navigator.pop(context);

      } catch (e) {
        loading = false;
        setState(() {});
      print("Error $e");
      }
    }
  }
 
 File? file;

  String? url1;
  getphoto() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file = File(photo.path);
      var imagename = basename(photo.path);
      final storageRef = FirebaseStorage.instance.ref("$imagename");
      await storageRef.putFile(file!);
      url1 = await storageRef.getDownloadURL();
    }
    setState(() {});
  }
  @override
  void dispose() {
    super.dispose();
    Title.dispose();
    Content.dispose();
  }

  bool goto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:  Drawer(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: selectedColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
          Icon(Icons.image,size: 100,color: Colors.white,),  
          Text("can add image",style: TextStyle(color: Colors.white,fontSize: 25),),
          IconButton(onPressed: getphoto, icon: Icon(Icons.add),color: Colors.white,)
        ])
         ),  
      backgroundColor: selectedColor, // Set background color
      appBar: AppBar(
        backgroundColor: selectedColor,
        leading: IconButton(
          onPressed: () {
            if (!goto) {
              
              AwesomeDialog(
                context: context,
                dialogType: DialogType.question,
                animType: AnimType.rightSlide,
                title: 'Exit',
                desc: 'Are you sure you want to discard your changes? If you want to save, click on save.',
                btnCancelOnPress: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => homepage()),
                    (route) => false,
                  );
                },
                btnOkText: 'Click icon save',
                btnCancelText: 'Cancel',
                btnOkOnPress: () {},
              ).show();
            } else {
               if (Content.text != "" || Title.text != "") {
                    Setuser(context);
                  }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => homepage()),
                (route) => false,
              );
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
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
                btnCancelOnPress: () {},
                btnOkText: 'Save',
                btnCancelText: 'Discard',
                btnOkOnPress: () {
                  goto = true;
                 
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Success Saving',
                    desc: 'Your changes saved successfully',
                  ).show();
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
             if (url1 != null) Card(child: Image.network(url1!)),
            TextField(
              controller: Content,
              style: TextStyle(color: Colors.white, fontSize: 20),
              maxLines:  100,
              decoration: InputDecoration(
                hintText: "Type something...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}


 
