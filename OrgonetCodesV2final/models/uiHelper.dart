import 'package:flutter/material.dart';

class UIhelper{
  static void showLoadingDialog(BuildContext context, String title){
    AlertDialog loadingDialog = AlertDialog(
      content: Container(

        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Colors.black,
            ),
            SizedBox(height: 28,),
            Center(child: Text(title,style: TextStyle(fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        barrierColor: Colors.black,
        barrierDismissible: false,
        builder: (context){
      return loadingDialog;
    });
  }
  static void showAlertDialog(BuildContext context,String title,String content){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Row(

              children: [
                SizedBox(width: 220,),
                Text("Okay",textAlign: TextAlign.left,),
                Icon(Icons.done,color: Colors.greenAccent,),
              ],
            ),
        )
      ],
    );
    showDialog(context: context, builder: (context){
      return alertDialog;
    });

}
}