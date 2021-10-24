import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orgonetchatappv2/models/FirebaseHelper.dart';
import 'package:orgonetchatappv2/pages/CompleteProfile.dart';
import 'package:orgonetchatappv2/pages/HomePage.dart';
import 'package:orgonetchatappv2/pages/LoginPage.dart';
import 'package:orgonetchatappv2/pages/SignUpPage.dart';
import 'package:uuid/uuid.dart';

import 'models/UserModel.dart';


var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentuser = FirebaseAuth.instance.currentUser;
  if(currentuser != null){
    // Logged In
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentuser.uid);
    if(thisUserModel != null){
      runApp(MyAppLoggedIn(
          userModel: thisUserModel,
          firebaseUser: currentuser
      )
    );
    }else{
      runApp(MyApp());
    }
  }else{
    // Not Logged In
    runApp(MyApp());
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        userModel: userModel,
        firebaseUser: firebaseUser,
      ),
    );
  }
}

