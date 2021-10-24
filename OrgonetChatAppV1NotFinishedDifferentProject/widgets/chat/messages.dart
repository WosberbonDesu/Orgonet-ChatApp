import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orgonetapp/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  //const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder:(ctx, futureSnapshot) {if(futureSnapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(color: Colors.indigo,),);
      }
        return StreamBuilder<QuerySnapshot>(
        builder: (ctx,chatSnapshot){
          if(chatSnapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = chatSnapshot.data!.docs;
          final user = FirebaseAuth.instance.currentUser;
              //if(!futureSnapshot.hasData){}
          return ListView.builder(
              reverse: true,
              itemCount: data.length,
              itemBuilder: (ctx,index) => MessageBubble(
                  data[index]['text'],
                  data[index]['userId'],
                  data[index]['userId'] == user!.uid,
                  key: ValueKey(data[index].id),
              )
            );
            },
            stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
          );
        },
    );
  }
}
