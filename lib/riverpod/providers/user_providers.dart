import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/riverpod/providers/auth_providers.dart';
import 'package:task_manager/services/firebase/auth/userInfoDb.dart';

final userProvider = FutureProvider<User?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(userProvider);
  return user.value?.uid;
});

final userDataProvider = FutureProvider<String?>((ref) async {
  String? userId = ref.watch(userIdProvider);
  return AuthDataBaseService().getCurrentUserInfo(userId);
});

final userEmailProvider = Provider((ref) {
  final user = ref.watch(authStateProvider);
  return user.value?.email;
});
