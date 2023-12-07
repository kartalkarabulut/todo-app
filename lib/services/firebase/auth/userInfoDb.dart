import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:intl/intl.dart';

class AuthDataBaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //CollectionReference users = firestore.collection("users");

  Future addUserInfo(Kullanici kullanici) async {
    try {
      CollectionReference users = firestore.collection("users");
      await users.doc(kullanici.userId).set(kullanici.toJson());
    } catch (e) {
      print("Firestora kayıt esnasında hata oluştu Hata.::: $e");
    }
  }

  Future<String?> getCurrentUserInfo(String? userId) async {
    var snapshot = await firestore.collection("users").doc(userId).get();
    final userData = snapshot.data() as Map<String, dynamic>;
    String? name = userData["name"] + " " + userData["surname"];
    return toBeginningOfSentenceCase(name);
  }
}
