import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';
import 'package:orgonetchatappv2/models/uiHelper.dart';
import 'package:orgonetchatappv2/pages/HomePage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseAuth;

  const CompleteProfile({Key? key, required this.userModel, required this.firebaseAuth})
      : super(key: key);

  //const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {

  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source)async{
    XFile? pickedFile =  await ImagePicker().pickImage(source: source);

    if(pickedFile != null){
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file)async{
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20,
    );
    if(croppedImage != null){
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showPhotoOptions(){

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text("Upload Profile Picture",style: TextStyle(fontWeight: FontWeight.bold),)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ListTile(
                  onTap: (){
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album,color: Colors.black,),
                  title: Text("Select From Gallery"),
                ),
                ListTile(
                  onTap: (){
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt,color: Colors.black),
                  title: Text("Take a Photo"),
                ),

              ],
            ),
          );
        }
    );

  }

  void checkValues(){
    String fullname = fullNameController.text.trim();

    if(fullname == "" || imageFile == null || fullname == "rte"){
      //print("Please fill all the fields");
      UIhelper.showAlertDialog(context, "Incomplete data", "Please fill all the fields");
    }else{
      uploadData();
    }
  }

  void uploadData()async{
    UIhelper.showLoadingDialog(context, "Uploading image...");
    UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();

    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap()).then((value) {
          print("Data uploaded!");
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context){
                  return HomePage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseAuth,
                  );
                }
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Complete Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40
          ),
          child: ListView(
            children: [
              SizedBox(height: 20,),
              CupertinoButton(
                onPressed: (){
                  showPhotoOptions();
                },
                padding: EdgeInsets.all(0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: (imageFile != null) ? FileImage(imageFile!) : null,
                  backgroundColor: Colors.black,
                  child: (imageFile == null) ? Icon(Icons.person,color: Colors.white,size: 60,) : null,
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.black)
                ),
              ),
              SizedBox(height: 20,),
              CupertinoButton(
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  color: Colors.black,
                  onPressed: (){
                    checkValues();
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
