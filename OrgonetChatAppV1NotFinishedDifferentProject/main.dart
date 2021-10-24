

import 'package:flutter/material.dart';
import 'package:orgonetapp/screens/auth_screen.dart';
import 'package:orgonetapp/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OrgoNet',
      theme: ThemeData(

        primarySwatch: Colors.indigo,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pinkAccent,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          )
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,userSnapshot)  {
          if(userSnapshot.hasData){
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}

