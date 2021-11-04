import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/appointment/selected_appointment.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({ Key? key }) : super(key: key);

  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {

  DatabaseService databaseMethods = new DatabaseService();

  Stream? appointmentStream;

  Widget appointmentList() {
    return StreamBuilder(
      stream: appointmentStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).documents.length,
          itemBuilder: (context, index) {
            return AppointmentsTile((snapshot.data! as QuerySnapshot ).documents[index]["appointmentID"], (snapshot.data! as QuerySnapshot).documents[index]["bundle"], (snapshot.data! as QuerySnapshot).documents[index]["time"]);
          },
        ) : Container(child: Text('You have no appointments'));
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState(); 
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getAppointments(Constants.myName).then((value){
      setState(() {
        appointmentStream = value;
      });
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appbar_appointment),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
          // ignore: deprecated_member_use
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: appointmentList()
    );
  }
}

class AppointmentsTile extends StatelessWidget {
  final String appointmentID;
  final String bundle;
  final String time;
  AppointmentsTile(this.appointmentID, this.bundle, this.time);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => AppointmentSelected(appointmentID: appointmentID),
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.appointment_bundle+': '+bundle),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.appointment_for+' '+appointmentID, style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),),
            Text(AppLocalizations.of(context)!.appointment_at+' '+time, style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),)
          ],
        ),
      ),
    );
  }
}