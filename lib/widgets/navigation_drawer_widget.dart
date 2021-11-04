import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/appointment/appointment.dart';
import 'package:my_app/screens/appointment/appointment_wrapper.dart';
import 'package:my_app/screens/appointment/see_appointment.dart';
import 'package:my_app/screens/helper/faq.dart';
import 'package:my_app/screens/helper/privacy.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:my_app/screens/wrapper.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final AuthService _auth = AuthService();
  DatabaseService databaseMethods = new DatabaseService();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  String username= '';
  String email= '';

  @override
  void initState() {
    getUserInfo();
    super.initState(); 
  }

  getUserInfo() async {
    username = await HelperFunctions.getUserNameSharedPreference();
    email = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color: Color.fromRGBO(63, 63, 156, 1),
        child: ListView(
          padding: padding,
          children: <Widget>[
            buildHeader(username: username, email: email),
            buildMenuItem(
              text: AppLocalizations.of(context)!.home_sideMenu,
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.appointment_sideMenu,
              icon: Icons.schedule,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.privacyPolicies_sideMenu,
              icon: Icons.policy,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.faq_sideMenu,
              icon: Icons.info,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.my_appointment_sideMenu,
              icon: Icons.schedule_send,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.white70),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            buildMenuItem(
              text: AppLocalizations.of(context)!.logout_sideMenu,
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String text, required IconData icon, VoidCallback? onClicked,}) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  Widget buildHeader({required String username, required String? email,}) {
    return Container(
      padding: padding.add(EdgeInsets.fromLTRB(0, 45, 0, 0)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 4),
              Text(email!, style: TextStyle(fontSize: 14, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  Future<void> selectedItem(BuildContext context, int index) async {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Wrapper(),
        ));
        break;

      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => AppointmentWraper(),
        ));
        break;

      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => PrivacyPolicies(),
        ));
        break;

      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Faq(),
        ));
        break;

      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MyAppointments(),
        ));
        break;

      case 5:
        await _auth.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Wrapper(),
        ));
        break;

    }
  }
}
