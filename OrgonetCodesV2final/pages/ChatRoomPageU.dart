import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orgonetchatappv2/main.dart';
import 'package:orgonetchatappv2/models/ChatRoomModel.dart';
import 'package:orgonetchatappv2/models/MessageModel.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';


class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;


  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom,
    required this.userModel, required  this.firebaseUser}) : super(key: key);



  //const ChatRoomPage({Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  void sendMessage()async{
    String msg = messageController.text.trim();
    messageController.clear();
    if(msg != ""){
      MessageModel  newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false
      );
      FirebaseFirestore.instance.collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages").doc(newMessage.messageid)
          .set(newMessage.toMap());
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
      log("Message Send");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                widget.targetUser.profilepic.toString()
              ),
            ),
            SizedBox(width: 10,),
            Text(widget.targetUser.fullname.toString(),style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid)
                          .collection("messages").orderBy("createdon",descending: true).snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.active){
                          if(snapshot.hasData){
                            QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                            return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index){
                                MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String,dynamic>);
                                return Row(
                                  mainAxisAlignment: (currentMessage.sender
                                      == widget.userModel.uid) ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10
                                      ),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender == widget.userModel.uid) ? Colors.grey.shade800 : Colors.black,
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                  ),
                                  ]
                                );
                              },
                            );
                          }else if(snapshot.hasError){
                            return Center(
                              child: Text("An error occured! Please check your internet connection",style: TextStyle(color: Colors.black),),
                            );
                          }else{
                            return Center(
                              child: Text("Say hi! to your new Friend.",style: TextStyle(color: Colors.black),),
                            );
                          }
                        }else{
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
              ),
              Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.black
                            ),
                            hintText: "Enter Message",
                          ),
                        ),
                    ),
                    IconButton(
                        onPressed: (){
                          sendMessage();
                        },
                        icon: Icon(Icons.send,color: Colors.black,),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
