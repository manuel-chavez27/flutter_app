import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/chat/chatRoomsScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/services/profile.dart';
import 'package:my_app/services/search.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:my_app/widgets/profile_widget.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AuthService _auth = AuthService();
  DatabaseService databaseMethods = new DatabaseService();
  final chatRoute = MaterialPageRoute(builder: (context) => ChatRoom());

  Stream? chatRoomsStream;

    @override
  void initState() {
    getUserInfo();
    super.initState(); 
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getEmployees(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
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
        title: Text('CarWash'),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: Container(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(AppLocalizations.of(context)!.admin_home),
              ),
              Flexible(
                child: employeesList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat_outlined),
        onPressed: () {
          _navigateToNextScreen(context);
        },
      ),*/
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChatRoom()));
  }

  Widget employeesList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).documents.length,
          itemBuilder: (context, index) {
            return employeesTile((snapshot.data! as QuerySnapshot ).documents[index]["username"].toString());
          },
        ) : Container();
      },
    );
  }
}

class employeesTile extends StatelessWidget {
  final String userName;
  employeesTile(this.userName);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage(userName: userName)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}", style: TextStyle(color: Colors.black, fontSize: 16),),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),)
          ],
        ),
      ),
    );
  }
}
