import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/chat/conversation_screen.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/services/profile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String? _myName;

class _SearchScreenState extends State<SearchScreen> {

  DatabaseService databaseMethods = new DatabaseService();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;


   Widget searchList(){
    return searchSnapshot !=null ? ListView.builder(
      itemCount: searchSnapshot!.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTitle(
          userName: searchSnapshot!.documents[index].data["username"],
          userEmail: searchSnapshot!.documents[index].data["email"],
        );
      }) : Container();
  }

  initiateSearch() {
    databaseMethods
      .getUserByUsername(searchTextEditingController.text)
      .then((val) {
        setState(() {
          searchSnapshot = val;
        });
      });
  }

  /// Create chatroom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String? userName}) {

    if(userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName!, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId" : chatRoomId
      };

      DatabaseService().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId),
      ));
    }else {
      print("You cannot send message to yourself");
    }
    
  }

  Widget SearchTitle({String? userName, String? userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName!),
              Text(userEmail!)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage(userName: userName)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Profile", style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(userName: userName);
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
    );
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54AAAAAA),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        hintText: "Search Username...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x180FFFFFF),
                            const Color(0x96FFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
   if ((a.compareTo(b) > 0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}