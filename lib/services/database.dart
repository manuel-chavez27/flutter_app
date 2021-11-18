import 'dart:math';
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

  Future<String>getRandomEmployee() async {
    String employee = '';
    int length = 0;
    Random random = new Random();
    int x = 0;
    await userCollection.where('role', isEqualTo: 'admin').getDocuments().then((value) => {
      length = value.documents.length,
      x = random.nextInt(length),
      //employee = value.documents.last.data['username']
      employee = value.documents.elementAt(x).data['username'].toString()
    });
    return employee;
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

  createAppointment(String appointmentID, appointmentMap) {
    Firestore.instance.collection('Appointment')
      .document(appointmentID).setData(appointmentMap).catchError((e){
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

  Future<bool> getChatRoomById(String id) async {
    //String id = '';
    /*await Firestore.instance.collection("ChatRoom").where('chatRoomId', isEqualTo: id).getDocuments().then((value) => {
      id = value.documents.first.data['email']
    });*/
    return await Firestore.instance.collection("ChatRoom").where('chatRoomId', isEqualTo: id).snapshots().isEmpty;
  }

  getEmployees(String username) async {
    return await Firestore.instance.collection("users")
      .where("role", isEqualTo: "admin")
      .snapshots();
  }

  getAppointments(String userName) async {
    return await Firestore.instance.collection("Appointment")
      .where("users", arrayContains: userName)
      .snapshots();
  }

  getAppointmentsBundle(String userName, int filter) async {
    return await Firestore.instance.collection("Appointment")
      .where("users", arrayContains: userName).where("bundle", isEqualTo: filter)
      .snapshots();
  }

  getAppointmentByID(String appointmentID) async {
    return await Firestore.instance.collection("Appointment")
      .where('appointmentID', isEqualTo: appointmentID)
      .snapshots();
  }

  getInitialLength(userName) async {
    int length = 1;
    await Firestore.instance.collection('Appointment').where("users", arrayContains: userName).getDocuments().then((value) {
      length = value.documents.length;
    });
    return length;
  }

  getLength(String option, String username) async {
    int length = 0;
    int bundlePicked;
    if(option=='Exterior Wash' || option=='Lavado Exterior') {
      bundlePicked=1;
    } else if(option=='Cleaning and Vacuuming' || option=='Lavado y Aspirado') {
      bundlePicked=2;
    } else{
      bundlePicked=3;
    }
    await Firestore.instance.collection('Appointment').where('users', arrayContains: username).getDocuments().then((value) {
      value.documents.forEach((element) {
        if(element.data.containsValue(bundlePicked)) {
          length++;
        }
      });
    });
    return length;
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