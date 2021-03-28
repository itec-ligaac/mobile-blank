import 'package:flutter/material.dart';

class AvatarPage extends StatefulWidget {
  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      
  
      home: Scaffold(
        appBar: AppBar(
          
       
          title: Text("blank"),
          backgroundColor: Color.fromRGBO(136, 100, 172, 100),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {

            },)
          ],
        ),
      ),
   );
  }
}