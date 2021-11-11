import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/screens/chat/conversation_screen.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/services/search.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_app/widgets/profile_widget.dart';
import 'package:provider/provider.dart';

class AppointmentSelected extends StatefulWidget {
  const AppointmentSelected({ Key? key, required this.appointmentID}) : super(key: key);

  final String appointmentID;

  @override
  _AppointmentSelectedState createState() => _AppointmentSelectedState();
}

class _AppointmentSelectedState extends State<AppointmentSelected> {

  DatabaseService databaseMethods = new DatabaseService();

  Stream? appointmentStream;


  Widget appointment() {
    return StreamBuilder(
      stream: appointmentStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).documents.length,
          itemBuilder: (context, index) {
            return AppointmentsInfo((snapshot.data! as QuerySnapshot ).documents[index]["address"], (snapshot.data! as QuerySnapshot).documents[index]["bundle"], (snapshot.data! as QuerySnapshot).documents[index]["time"], (snapshot.data! as QuerySnapshot).documents[index]["city"], (snapshot.data! as QuerySnapshot).documents[index]["date"], (snapshot.data! as QuerySnapshot).documents[index]["zip"], (snapshot.data! as QuerySnapshot).documents[index]["users"].toString().replaceAll("[", "").replaceAll("]", "").replaceAll(",", "").replaceAll(Constants.myName, ""), context, databaseMethods);
          },
        ) : Container(child: Text('data'),);
      },
    );
  }

    @override
  void initState() {
    getAppointment();
    super.initState(); 
  }

  getAppointment() async {
    databaseMethods.getAppointmentByID(widget.appointmentID).then((value){
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
      body: appointment(),
    );
  }
}

class AppointmentsInfo extends StatelessWidget {
  final String address;
  final int bundle;
  final String time;
  final String city;
  final String date;
  final String zip;
  final String users;
  final DatabaseService databaseMethods;
  final BuildContext context;
  AppointmentsInfo(this.address, this.bundle, this.time, this.city, this.date, this.zip, this.users, this.context, this.databaseMethods);

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

  /// Create chatroom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String? userName}) async {
    if(userName != Constants.myName) {
      String chatRoomId = date+'_'+time;
      bool chatRoomExist = await databaseMethods.getChatRoomById(chatRoomId);

      print(chatRoomExist);
      
      if(chatRoomExist) {
        List<String> users = [userName!, Constants.myName];
        Map<String, dynamic> chatRoomMap = {
          "users": users,
          "chatRoomId" : chatRoomId
        };

        DatabaseService().createChatRoom(chatRoomId, chatRoomMap);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId, userName),
        ));
      }else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId, userName!),
        ));
      }

    }else {
      print("You cannot send message to yourself");
    }
    
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<TheUser>(context);
      checkRole(DocumentSnapshot? snapshot) {
        if (snapshot!.data['role'] == 'admin') {
          return employee();
        } else {
          return customer();
        }
      }

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

  Widget customer() {
    getBundle(bundle, context);
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.appointment_info, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.appointment_address, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_address, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(address),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_city, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(city),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_zip, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(zip),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.appointment_date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_date, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(date),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_time, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(time),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.appointment_employee, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ProfileWidget(
                          imagePath: 'https://i.insider.com/5899ffcf6e09a897008b5c04?width=1000&format=jpeg&auto=webp',
                          onClicked: () async {},
                        ),
                        Text(users, style: TextStyle(fontSize: 20)),
                        GestureDetector(
                          onTap: (){
                            createChatroomAndStartConversation(userName: users);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Text("Chat", style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(bundlePicked!),
          ],
        ),
    );
  }

  Widget employee() {
    getBundle(bundle, context);
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(AppLocalizations.of(context)!.appointment_info, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.appointment_address, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_address, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(address),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_city, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(city),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_zip, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(zip),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.appointment_date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_date, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(date),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  child: Text(AppLocalizations.of(context)!.appointment_time, style: TextStyle(color: Colors.grey[600])),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(time),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.appointment_employee, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ProfileWidget(
                          imagePath: 'https://i.insider.com/5899ffcf6e09a897008b5c04?width=1000&format=jpeg&auto=webp',
                          onClicked: () async {},
                        ),
                        Text(Constants.myName, style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: (){
                            createChatroomAndStartConversation(userName: users);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Text(AppLocalizations.of(context)!.appointment_chat, style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(bundlePicked!),
          ],
        ),
    );
  }
}