import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/authenticate/authenticate.dart';
import 'package:my_app/screens/authenticate/verify_email.dart';
import 'package:my_app/screens/home/admin.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<TheUser>(context);

    if(user == null) {
      return Authenticate();
    }else {
      if(user.isEmailVerified == false) {
        return verifyEmail();
      }else {
        return StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(user.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasError){
              print('Error: ${snapshot.error}');
            }
            switch(snapshot.connectionState){
              case ConnectionState.waiting: print('Loading...'); break;
              default:
                return checkRole(snapshot.data);
            }
            return Loading();//This would place the widget load while the role verification is in progress
          }
        );
      }
    }
  }

  checkRole(DocumentSnapshot? snapshot){
    if(snapshot!.data['role'] == 'admin'){
      return Admin();
    }else {
      return Home();
    }
  }  
}


/*
final user = Provider.of<TheUser>(context);

    String myDocId = 'user.uid';
    DocumentSnapshot ?documentSnapshot;

    Firestore.instance
      .collection('users')
      .document(myDocId)
      .get()
      .then((value){
        documentSnapshot = value;
      });

    final role = documentSnapshot?['role'];
    print('Role = ${role}');

      if(user == null) {
        return Authenticate();
      }else {
        if(user.isEmailVerified == false) {
          return verifyEmail();
        }else {
          if(role=='admin'){
            return Admin();
          }
        return Home();
      }
    }
*/