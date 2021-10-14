import 'package:flutter/material.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/widgets/button_widget.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/numbers.widget.dart';
import 'package:my_app/widgets/profile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final userName;
  const ProfilePage({ Key? key, this.userName }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String _selectedItem = '';
  DatabaseService databaseMethods = new DatabaseService();
  String username= '';
  String email= '';
  String role = '';

  @override
  void initState() {
    getUserInfo();
    //super.initState(); 
  }

  getUserInfo() async {
    username = widget.userName;
    email = await databaseMethods.getEmailByUserName(username);
    role = await databaseMethods.getRoleByUsername(username);
    setState(() { 
    });
  }

  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        title: Text('CarWash'),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: 'https://i.insider.com/5899ffcf6e09a897008b5c04?width=1000&format=jpeg&auto=webp',
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(username, email, role),
          const SizedBox(height: 24),
          Center(child: buildEditButton(username)),
          const SizedBox(height: 24),
          NumbersWidget(),
        ],
      ),
    );
  }

  Widget buildName(String username, String email, String role) => Column(
    children: [
      Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      Text(
        email,
        style: TextStyle(color: Colors.grey),
      ),
      const SizedBox(height: 24),
      Text(
        AppLocalizations.of(context)!.profile_role+': $role',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      )
    ],
  );


  Widget buildEditButton(String username) => ButtonWidget(
    text: AppLocalizations.of(context)!.profile_edit_role,
    onClicked: () {
      _displayOptions(username);
    },
  );

  void _displayOptions(String username) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        color: Color(0xFF737373),
        height: 120,
        child: Container(
          child: _buildBottomNavigationMenu(),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            )
          ),
        ),
      );
    });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
        children: <Widget>[
          ListTile(
            title: Text('Admin'),
            onTap: () async {
              await databaseMethods.updateUserRole(username, 'admin');
              Navigator.pop(context);
              initState();
            },
          ),
          ListTile(
            title: Text('Customer'),
            onTap: () async {
              await databaseMethods.updateUserRole(username, 'customer');
              Navigator.pop(context);
              initState();
            },
          )
        ],
      );
  }

}