import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orgonetapp/widgets/chat/messages.dart';
import 'package:orgonetapp/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: RichText(
          text: TextSpan(
            children: const <TextSpan>[
              TextSpan(text: 'Orgo',style: TextStyle(fontSize: 20)),
              TextSpan(text: 'NET',style: TextStyle(fontSize: 24,color: Colors.yellowAccent)),
            ],
          ),
        ),
        actions: <Widget>[
          DropdownButton(
            focusColor: Colors.redAccent,
            items: [
              DropdownMenuItem(child: Container(
                color: Colors.red,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8,),
                    Text("Logout")
                  ],
                ),
              ),
                value: 'logout',
              )
            ],
            icon: Icon(Icons.more_vert,color: Colors.white,),
            onChanged: (itemIdentifier){
              if(itemIdentifier == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey.shade900,
        child: Column(children: <Widget>[
          Expanded(
              child: Messages()
          ),
          NewMessage(),
        ],
        ),
      ),
      //StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore
          //.instance
          //.collection('chats/8C7i5jd9NP2AEI5OU5TU/messages')
          //.snapshots(), builder: (ctx,streamSnapshot) {
        //if(streamSnapshot.connectionState == ConnectionState.waiting){
          //return Center(child: CircularProgressIndicator(),);
       // }
        //final data = streamSnapshot.data;
        //return ListView.builder(
          //itemCount: data!.size,
          //itemBuilder: (ctx,index) => Container(
            //padding: EdgeInsets.all(8),
            //child: Text(data.docs[index]['text']),
          //),
        //);
      //},
      //),
      //floatingActionButton: FloatingActionButton(
        //child: Icon(Icons.add),
        //onPressed: (){
          //FirebaseFirestore.instance.collection('chats/8C7i5jd9NP2AEI5OU5TU/messages').add({
            //'text': 'This was added by Skogsra'
          //});
        //},
      //),
    );
  }
}




