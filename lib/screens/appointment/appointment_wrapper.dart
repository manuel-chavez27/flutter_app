import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/appointment/admin_appointment.dart';
import 'package:my_app/screens/appointment/appointment.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:provider/provider.dart';

class AppointmentWraper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

      return StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(user.uid)
              .snapshots(),
          builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                print('Loading...');
                break;
              default:
                return checkRole(snapshot.data);
            }
            return Loading(); //This would place the widget load while the role verification is in progress
          });
    }

  checkRole(DocumentSnapshot? snapshot) {
    if (snapshot!.data['role'] == 'admin') {
      return AppointmentEmployees();
    } else {
      return Appointment();
    }
  }
}