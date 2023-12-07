import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/services/firebase/auth/userInfoDb.dart';
import 'package:task_manager/services/firebase/todos/todo_services.dart';

class AuthenticationServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthDataBaseService cloud = AuthDataBaseService();
  TodoServices todoServices = TodoServices();
  Future register(Kullanici kullanici) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: kullanici.email,
        password: kullanici.password,
      );
      final userId = userCredential.user!.uid;
      kullanici.userId = userId;
      await cloud.addUserInfo(kullanici);
      await todoServices.createCategory(userId, "General");
    } catch (e) {
      print("auth register esnasında genel bir hata :::: $e");
    }
  }

  Future login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  logOut() async {
    await auth.signOut();
  }
}
