import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key? key}) : super(key: key);
  final String message;
  final bool isMe;
  final String userId;
  final Key? key;
  MessageBubble(this.message,this.userId,this.isMe,{this.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
        decoration: BoxDecoration(
          color: isMe ? Colors.blueGrey : Colors.grey.shade800,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
          ),
        ),
        width: 140,
        padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16
        ),
        margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
        ),
        child: Column(
          children: <Widget>[
            FutureBuilder<Object>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (ctx,AsyncSnapshot<dynamic> futureSnapshot){
                if(futureSnapshot.connectionState == ConnectionState.waiting){
                  return Text('Loading...');
                }

                return Text(
                  //futureSnapshot.data!["username"],
                  "a",
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold),
                );
              }
            ),
            Text(message,
            style: TextStyle(
            color: isMe
                ? Colors.white
                : Colors.white
          ),
          ),
          ],
        ),

    ),
      ],
        );
  }
}
