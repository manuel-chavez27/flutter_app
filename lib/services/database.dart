import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String ?uid;
  DatabaseService({ this.uid });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  
  Future updateUserData(String role, String username, String email) async {
    return await userCollection.document(uid).setData({
      'role': role,
      'username': username,
      'email': email,
    });
  }

  // Get Users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  getUserByUsername(String username) async {
    return await Firestore.instance.collection('users')
    .where("username", isEqualTo: username)
    .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection('users')
    .where("email", isEqualTo: userEmail)
    .getDocuments();
  }

  // Get Specific field from doc
  Future<String> getEmailByUserName(String username, String uid) async {
    String email = '';
    await userCollection.document(uid).get().then((value) {
      email = value.data['email'].toString();
    });
    return email;
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance.collection("ChatRoom")
      .document(chatRoomId).setData(chatRoomMap).catchError((e){
        print(e.toString());
      });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance.collection("ChatRoom")
      .document(chatRoomId)
      .collection("chats")
      .add(messageMap).catchError((e){print(e.toString());});
  }
  
  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance.collection("ChatRoom")
      .document(chatRoomId)
      .collection("chats")
      .orderBy("time", descending: false)
      .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance.collection("ChatRoom")
      .where("users", arrayContains: userName)
      .snapshots();
  }

  getEmployees(String username) async {
    return await Firestore.instance.collection("users")
      .where("role", isEqualTo: "admin")
      .snapshots();
  }

}