import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormScreen> {

  String radioItem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Vertical custom Radio Button'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RadioListTile(
            activeColor: Colors.indigo,
            groupValue: radioItem,
            title: Text('Abc',style: TextStyle(color: Colors.black54,fontSize:15)),
            value: 'Item 1',
            onChanged: (String? val) {
              setState(() {
                radioItem = val!;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.indigo,
            groupValue: radioItem,
            title: Text('Xyz',style: TextStyle(color: Colors.black54,fontSize:15)),
            value: 'Item 2',
            onChanged: (String? val) {
              setState(() {
                radioItem = val!;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.indigo,
            groupValue: radioItem,
            title: Text('Pqr',style: TextStyle(color: Colors.black54,fontSize:15)),
            value: 'Item 3',
            onChanged: (String? val) {
              setState(() {
                radioItem = val!;
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.indigo,
            groupValue: radioItem,
            title: Text('Abc',style: TextStyle(color: Colors.black54,fontSize:15)),
            value: 'Item 4',
            onChanged: (String? val) {
              setState(() {
                radioItem = val!;
              });
            },
          ),
        ],
      ),
    );
  }
}
