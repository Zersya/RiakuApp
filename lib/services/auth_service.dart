import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/my_response.dart';

import 'dart:io';

import 'package:riaku_app/utils/strCode.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  Future<MyResponse> loginUser(User user) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .document(user.email)
          .snapshots()
          .first;

      user = User(doc.data['email'], username: doc.data['username'], id: doc.data['id']);

      return MyResponse<User>(ResponseState.SUCCESS, user,
          message: LocDelegate.currentLoc.success.successLogin);
    } on SocketException {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on PlatformException catch (err) {
      return MyResponse(ResponseState.ERROR, null, message: err.message);
    } on Exception catch (err) {
      return MyResponse(ResponseState.ERROR, null, message: err.toString());
    }
  }

  Future<MyResponse> createUser(User user) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .document(user.email)
          .snapshots()
          .first;

      if (doc.data == null) {
        await _auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);

        await _firestore
            .collection('users')
            .document(user.email)
            .setData(user.toMap());

        return MyResponse(ResponseState.SUCCESS, null,
            message: LocDelegate.currentLoc.success.successCreate);
      } else {
        throw PlatformException(
            code: kEmailRegisteredCode,
            message: LocDelegate.currentLoc.error.emailRegisteredError);
      }
    } on SocketException {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on PlatformException catch (err) {
      return MyResponse(ResponseState.ERROR, null, message: err.message);
    } on Exception catch (err) {
      return MyResponse(ResponseState.ERROR, null, message: err.toString());
    }
  }
}
