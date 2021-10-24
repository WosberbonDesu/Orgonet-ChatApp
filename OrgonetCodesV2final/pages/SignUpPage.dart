import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';
import 'package:orgonetchatappv2/models/uiHelper.dart';
import 'package:orgonetchatappv2/pages/CompleteProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();


  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == ""){
      //print("Please fill all the fields");
      UIhelper.showAlertDialog(context, "Incomplete data", "Please fill all the areas");
    }else if(password != cPassword){
      //print("Passwords not matching");
      UIhelper.showAlertDialog(context, "Password Mismatch", "The password you entered not same try again");
    }else{
      signUp(email, password);
    }
  }

  void signUp(String email, String password,) async{
    UserCredential? credential;
    UIhelper.showLoadingDialog(context, "Creating new account");

    try{
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }on FirebaseAuthException catch(ex){
      Navigator.pop(context);
      UIhelper.showAlertDialog(context, "An error occured", ex.code.toString());
      //print(ex.code.toString());
    }
    if(credential != null){
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value)  {
        print("New user created");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context){
                  return CompleteProfile(
                    userModel: newUser,
                    firebaseAuth: credential!.user!,
                  );
                })
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Icon(Icons.remove_red_eye_sharp,size: 20,color: Colors.black,),
                  Text("OrgoNET",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email,color: Colors.black,),
                        labelText: "Email Address",
                        //hintText: "Email",
                        labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock,color: Colors.black,),
                        labelText: "Password",
                        //hintText: "Password",
                        labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextField(
                    controller: cPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock,color: Colors.black,),
                        labelText: "Confirm Password",
                        //hintText: "Password",
                        labelStyle: TextStyle(color: Colors.black)
                    ),
                  ),
                  SizedBox(height: 20,),
                  CupertinoButton(
                    child: Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    onPressed: (){
                      checkValues();
                    },
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(
                  color: Colors.blueGrey,fontSize: 16,fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
              child: Text(
                'Log In',
                style: TextStyle(
                    color: Colors.black,

                    fontSize: 16,fontWeight: FontWeight.bold),
              ),
              onPressed:(){
                Navigator.pop(context);
              }, )
          ],
        ),
      ),
    );
  }
}
