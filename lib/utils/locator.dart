import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/services/auth_service.dart';

GetIt getIt = GetIt.instance;

void locator(Firestore firestore, FirebaseAuth auth, bool isTest) {
  if (isTest) {
    getIt.reset();
  }


  getIt.registerLazySingleton<AuthService>(() => AuthService(firestore, auth));
}
