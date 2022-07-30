
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plannerapp/src/leaves/LeavesScreen.dart';
import 'package:plannerapp/src/screens/DashboardScreen.dart';
import 'package:plannerapp/src/screens/ExecutionList.dart';



class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerScreen> {
  int _selectedDestination = 0;
  var activeScreen = DashboardScreen();
  final ImagePicker _picker = ImagePicker();
  late PickedFile? _imageFile = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Row(
        children: [
          Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      imageProfile(),
                    ],
                  )
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: Image.asset('assets/img/home.png',height: 20, width: 20, ),
                  title: Text('Home', style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),),
                  selected: _selectedDestination == 0,
                  onTap: () => selectDestination(0),
                ),
                ListTile(
                  leading: Image.asset('assets/img/executed.png',height: 20, width: 20, ),
                  title: Text('Planned List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  selected: _selectedDestination == 1,
                  onTap: () => selectDestination(1),
                ),
                ListTile(
                  leading: Image.asset('assets/img/plans.png',height: 20, width: 20,  ),
                  title: Text('Executed List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  selected: _selectedDestination == 2,
                  onTap: () => selectDestination(2),
                ),
                ListTile(
                  leading: Image.asset('assets/img/executed.png',height: 20, width: 20,  ),
                  title: Text('Approval List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  selected: _selectedDestination == 3,
                  onTap: () => selectDestination(3),
                ),

                Divider(
                  height: 1,
                  thickness: 1,
                ),

                ListTile(
                  leading: Icon(Icons.weekend , size: 20,),
                  title: Text('Leaves List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  selected: _selectedDestination == 4,
                  onTap: () => selectDestination(4),
                ),
                ListTile(
                  leading: Icon(Icons.logout, size: 20,),
                  title: Text('Logout', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  selected: _selectedDestination == 5,
                  onTap: () => selectDestination(5),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
      if(_selectedDestination == 1){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeavesScreen()),
        );

      }
    });
  }

  Widget imageProfile() {

    return Center(
      child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: Center(
            child: CircleAvatar(
              radius: 34,
              backgroundImage: _imageFile == null
                  ? Image.asset("assets/img/profile.png" , fit: BoxFit.fill,).image
                  : FileImage(File(_imageFile!.path)),
            ),
          )
        // CircleAvatar(
        //   radius: 65.0,
        //
        //   backgroundImage: _imageFile == null
        //       ? Image.asset("assets/img/profileavatar").image
        //       : FileImage(File(_imageFile!.path)),
        // ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera,color: Colors.grey),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera",
                style: TextStyle(
                    color: Colors.black
                ),),
            ),
            SizedBox(width: 40,),
            TextButton.icon(
              icon: Icon(Icons.image, color: Colors.grey,),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery",
                style: TextStyle(
                    color: Colors.black
                ),),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
      Navigator.pop(context);
    });
  }


}


