import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';
import 'package:orgonetchatappv2/models/uiHelper.dart';
import 'package:orgonetchatappv2/pages/HomePage.dart';
import 'package:orgonetchatappv2/pages/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == '' || password == ''){
      UIhelper.showAlertDialog(context, "Incomplete data", "Please fill al the fields and try again");
      //print("Please fill all the fields");
    }
    else{
      logIn(email,password);
    }
  }

  void logIn(String email, String password)async{

    UserCredential? credential;
    UIhelper.showLoadingDialog(context, "Logging in\nWelcome to OrgoNET");


    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(ex){
      // Close the loading Dialog
      Navigator.pop(context);
      UIhelper.showAlertDialog(context, "An error occured", ex.message.toString());
      //print(ex.message.toString());
    }
    if(credential != null){
      String uid = credential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String,dynamic>);
      print("Log in is success");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context){
                return HomePage(
                  userModel: userModel,
                  firebaseUser: credential!.user!,
                );
              }
          )
      );
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
                  SizedBox(height: 20,),
                  CupertinoButton(
                      child: Text("Log In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      onPressed: (){
                        checkValues();
                      },
                    color: Colors.black,
                  ),
                  SizedBox(height: 30,),
                  IconButton(
                    onPressed: (){},
                    icon: Image.asset("images/Prime_logo.png",height: 40,),

                    splashColor: Colors.black,
                    iconSize: 120.0,
                    tooltip: "Hellö",
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
              "Don't have an account?",
              style: TextStyle(
                  color: Colors.blueGrey,fontSize: 16,fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,fontWeight: FontWeight.bold),
                ),
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context){
                          return SignUpPage();
                        }
                    )
                  );
                }, )
          ],
        ),
      ),
    );
  }
}
