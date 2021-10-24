import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:orgonetchatappv2/models/ChatRoomModel.dart';
import 'package:orgonetchatappv2/models/FirebaseHelper.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';
import 'package:orgonetchatappv2/models/uiHelper.dart';
import 'package:orgonetchatappv2/pages/ChatRoomPageU.dart';
import 'package:orgonetchatappv2/pages/LoginPage.dart';
import 'package:orgonetchatappv2/pages/SearchPage.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);


  //const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: Drawer(
        child: Container(
          color: Colors.yellowAccent,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 100),
            children: [
              Center(child: Text("NAME",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),),
              Center(child: Text(widget.userModel.fullname.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))),
              CircleAvatar(
                  backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                  widget.userModel.profilepic.toString(),
                  scale: 1
                  )
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('OrgoNET',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context){
                      return LoginPage();
                    })
                );
              },
              icon: Icon(Icons.exit_to_app,color: Colors.redAccent,)
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms")
                .where("participants.${widget.userModel.uid}",isEqualTo: true)
                .snapshots(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context,index){
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data() as Map<String,dynamic>
                      );
                      Map<String,dynamic> participants = chatRoomModel.participants!;
                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);
                      return FutureBuilder(
                          future: FirebaseHelper.getUserModelById(participantKeys[0]),
                          builder: (context,userData){
                            if(userData.connectionState == ConnectionState.done){
                              if(userData.data != null){
                                UserModel targetUser = userData.data as UserModel;
                                return ListTile(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context){
                                            return ChatRoomPage(
                                                targetUser: targetUser,
                                                chatroom: chatRoomModel,
                                                userModel: widget.userModel,
                                                firebaseUser: widget.firebaseUser
                                            );
                                          }
                                      )
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        targetUser.profilepic.toString()
                                    ),
                                  ),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: (chatRoomModel.lastMessage.toString() != "")
                                      ? Text(chatRoomModel.lastMessage.toString())
                                      : Text("No message send yet, say hi to your friend",style: TextStyle(color: Colors.redAccent),),
                                );
                              }else{
                                return Container(
                                  child: Text("No user added yet"),
                                );
                              }
                            }else{
                              return Container(
                                child: Text("No user added yet"),
                              );
                            }
                          }
                      );
                    },
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }else{
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          //UIhelper().showLoadingDialog(context,"Loading...");

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return SearchPage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser
                );
              })
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
