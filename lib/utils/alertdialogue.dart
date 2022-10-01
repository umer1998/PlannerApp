import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlertDialogue{

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$message"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  AlertDialogue? showLoader(BuildContext context) {


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Container(color: Colors.transparent ,child: Center(child: LoadingAnimationWidget.inkDrop(color: Colors.redAccent, size: 40 ,)))
        ],
          ),
      actions: [
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}