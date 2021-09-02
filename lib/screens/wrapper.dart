import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/authenticate/authenticate.dart';
import 'package:my_app/screens/authenticate/verify_email.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    final user = Provider.of<TheUser>(context);
    

    // return either Home or Authenticate widget
    /*if(user == null) {
      return Authenticate();
    }else if(user.isEmailVerified == false){
      print('Email status: ${user.isEmailVerified}');
      return verifyEmail();
    } else {
      print('Email status: ${user.isEmailVerified}');
      return Home();
    }*/

    if(user == null) {
      return Authenticate();
    }else {
      if(user.isEmailVerified == false) {
        return verifyEmail();
      }else {
        return Home();
      }
    }

  }
}

/*
AlertDialog alert = AlertDialog(  
          title: Text("Simple Alert"),  
          content: Text("This is an alert message."),  
          actions: [  
            // ignore: deprecated_member_use
            FlatButton(  
              child: Text("OK"),  
              onPressed: () {  
                Navigator.of(context).pop();  
              },  
            ),  
          ],  
        )

*/