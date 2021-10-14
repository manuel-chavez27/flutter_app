import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  getUidByUsername(String username) async {
    return await username.toString();
  }

  
  /*
  * Get Specific field from doc
  ! If you want to get the value from a Future, you have to await the future (see profile.dart for reference)
  */
  Future<String> getEmailByUserName(String username) async {
    String email = '';
    await userCollection.where('username', isEqualTo: username).getDocuments().then((value) => {
      email = value.documents.first.data['email']
    });
    return email;
  }

  Future<String> getRoleByUsername(String username) async {
    String role = '';
    await userCollection.where('username', isEqualTo: username).getDocuments().then((value) => {
      role = value.documents.first.data['role']
    });
    return role;
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

  // Update Doc
  Future<void> updateUserRole(String username, String role) async {
    String uid = '';
    /*
    ? How to get the UID from a doc from Firestore
    */
    await userCollection.where('username', isEqualTo: username).getDocuments().then((value) => {
      uid = value.documents.first.documentID
    });
    return await Firestore.instance.collection("users")
      .document(uid)
      .setData({"role" : role}, merge: true);
  }

}