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

  String? filter;
  int? length;
  int bundle = 401;

  Stream? appointmentStream;


  getInitialLength() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    length = await databaseMethods.getInitialLength(Constants.myName);
    print("Tienes un total de citas: $length");
    setState(() {
      length = this.length!;
    });
  }

  Widget appointmentList(length) {
    return StreamBuilder(
      stream: appointmentStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: length,
          itemBuilder: (context, index) {
            print('Tamaño total: $length');
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
  if(bundle==401) {
    print('Calculando sin bundle');
    getInitialLength();
    databaseMethods.getAppointments(Constants.myName).then((value){
      setState(() {
        appointmentStream = value;
      });
    });
  } else {
    print('Bundle value: $bundle');
    databaseMethods.getAppointmentsBundle(Constants.myName, bundle).then((value){
      setState(() {
        appointmentStream = value;
      });
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = [AppLocalizations.of(context)!.first_bundle, AppLocalizations.of(context)!.second_bundle, AppLocalizations.of(context)!.third_bundle];
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: filter,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                iconSize: 36,
                items: items.map(buildMenuItem).toList(),
                onChanged: (value) async {
                 setState(() {
                   this.filter = value;
                   if(value=='Exterior Wash' || value=='Lavado Exterior') {
                      bundle=1;
                    } else if(value=='Cleaning and Vacuuming' || value=='Lavado y Aspirado') {
                      bundle=2;
                    } else{
                      bundle=3;
                    }
                 });
                 length = await databaseMethods.getLength(filter!, Constants.myName);
                 setState(() {
                   appointmentList(length);
                 });
                 getUserInfo();
                } 
              ),
            ),
          ),
          Text('Tamaño: $length'),
          Expanded(
            child: SizedBox(
              child: appointmentList(length),
            ),
          ),
        ],
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  value: item,
  child: Text(
      item,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

class AppointmentsTile extends StatelessWidget {
  final String appointmentID;
  final int bundle;
  final String time;
  AppointmentsTile(this.appointmentID, this.bundle, this.time);

  String? bundlePicked;

  getBundle(bundle, context) {
    if(bundle==1) {
      bundlePicked = AppLocalizations.of(context)!.first_bundle;
    } else if(bundle==2) {
      bundlePicked = AppLocalizations.of(context)!.second_bundle;
    } else if(bundle==3) {
      bundlePicked = AppLocalizations.of(context)!.third_bundle;
    }
  }

  @override
  Widget build(BuildContext context) {
    getBundle(bundle, context);
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
            Text(AppLocalizations.of(context)!.appointment_bundle+': '+bundlePicked!),
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