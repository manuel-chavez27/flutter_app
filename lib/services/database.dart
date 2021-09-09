import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String ?uid;
  DatabaseService({ this.uid });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  
  Future updateUserData(String role) async {
    return await userCollection.document(uid).setData({
      'role': role,
    });
  }

  // Get Users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

}