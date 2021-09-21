import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/chat/videochat.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ConversationScreen(this.chatRoomId, [this.userName =""]);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseService databaseMethods = new DatabaseService();
  TextEditingController messageController = new TextEditingController();
  
  Stream? chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? Container(
          padding: EdgeInsets.only(bottom: 70),
          height: MediaQuery.of(context).size.height - 80,
          child: ListView.builder(
              itemCount: (snapshot.data! as QuerySnapshot).documents.length,
              itemBuilder: (context, index) {
                return MessageTile ((snapshot.data! as QuerySnapshot ).documents[index]["message"], (snapshot.data! as QuerySnapshot ).documents[index]["sendBy"] == Constants.myName);
              }),
        ) : Container();
      },
    );
  }


  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy" : Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => videoChat()));
            },
            child: Icon(Icons.video_call),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54AAAAAA),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          keyboardType: TextInputType.multiline, maxLines: null,
                          controller: messageController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Send Message",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0x9F007EF4),
              const Color(0X9F2A75BC)
            ]
            :
            [
              const Color(0x5A3F3F9C),
              const Color(0x5A3F3F9C)
            ],
          ),
          borderRadius: isSendByMe ?
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
            )
        ),
        child: Text(
          message, style: TextStyle(
          color: Colors.black,
          fontSize: 16
          ),
        ),
      ),
    );
  }
}