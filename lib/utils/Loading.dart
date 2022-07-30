import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {



  @override
  Widget build(BuildContext context) {

    return
      Container(
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.5)
        ),
        child: Center(
     child: LoadingAnimationWidget.inkDrop(color: Colors.redAccent, size: 40 ,),
    ),
      );
  }
  


  @override
  void initState() {
    // Timer(
    //     Duration(seconds: 5),
    //         () =>
    //             Navigator.push(context, PageTransition(type: PageTransitionType.fade , duration: Duration(seconds: 1),
    //                 child: SafeArea(child: HomeScreen()))));


  }
}
