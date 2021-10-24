import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orgonetchatappv2/main.dart';
import 'package:orgonetchatappv2/models/ChatRoomModel.dart';
import 'package:orgonetchatappv2/models/UserModel.dart';
import 'package:orgonetchatappv2/pages/ChatRoomPageU.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key,required this.userModel,required this.firebaseUser}) : super(key: key);

  //const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser)async{
    ChatRoomModel? chatRoom;

   QuerySnapshot snapshot =  await FirebaseFirestore.instance.collection("chatrooms")
        .where("participants.${widget.userModel.uid}",isEqualTo: true)
        .where("participants.${targetUser.uid}",isEqualTo: true).get();

   if(snapshot.docs.length > 0){

     //log("Chat room already created!");
     var docData = snapshot.docs[0].data();
     ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
     chatRoom = existingChatroom;

   }else{
     ChatRoomModel newChatroom = ChatRoomModel(
       chatroomid: uuid.v1(),
       lastMessage: "",
       participants: {
         widget.userModel.uid.toString(): true,
         targetUser.uid.toString(): true,
       }
     );
     await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());
     chatRoom = newChatroom;
     log("Chat room npt created yet!");
   }
   return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    String a = "Watching you";
    return Scaffold(

      backgroundColor: Colors.yellowAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock,color: Colors.black,),
                  labelText: "Email Address",
                  labelStyle: TextStyle(color: Colors.black)
                ),
              ),
              SizedBox(height: 20,),
              CupertinoButton(
                  child: Text("Search",style: TextStyle(color: Colors.white),),
                  color: Colors.black,
                  onPressed: (){
                    setState(() {

                    });
                  }
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users")
                    .where("email",isEqualTo: searchController.text)
                    .where("email",isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.active){
                    if(snapshot.hasData){
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                      if(dataSnapshot.docs.length > 0){
                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: ()async{
                            ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);
                            if(chatroomModel != null) {
                                Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context){
                                        return ChatRoomPage(
                                          targetUser: searchedUser,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                          chatroom: chatroomModel,
                                    );
                                  }
                                  )
                                );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              searchedUser.profilepic!
                            ),
                            backgroundColor: Colors.blueGrey,
                          ),
                          title: Text(searchedUser.fullname!),
                          subtitle: Text(searchedUser.email!),
                          trailing: Icon(Icons.keyboard_arrow_right,color: Colors.black,),
                        );
                      }
                      else{
                        return Text("No results found",style: TextStyle(fontWeight: FontWeight.bold),);
                      }
                    }
                    else if(snapshot.hasError){
                      return Text("An error occured");
                    }
                    else{
                      return Text("No results found");
                    }
                  }
                  else{
                    return CircularProgressIndicator(color: Colors.black,);
                  }
                },
              ),
              SizedBox(height: 100,),
              Icon(Icons.remove_red_eye,size: 50,),
              Text(a,style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}
