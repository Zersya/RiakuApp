import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/auth/login/login_bloc.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/locator.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestore extends Mock implements Firestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  String documentID = '123';
  Map<String, dynamic> data = {
    'id': 'mail@mail.com',
    'username': 'mail-mail',
    'email': 'mail@mail.com'
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockFirestore firestore;
  MockFirebaseAuth auth;
  LocDelegate locDelegate;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    firestore = MockFirestore();
    auth = MockFirebaseAuth();

    locator(firestore, auth, true);

    locDelegate = LocDelegate();
    locDelegate.load(Locale('en'));
  });

  group('Login UI', () {
    test('check visible pass', () async {
      LoginBloc bloc = LoginBloc();

      bloc.setVisibility(false);
      bool isVisible = bloc.isVisibleStream.value;
      expect(isVisible, false);

      bloc.setVisibility(true);
      isVisible = bloc.isVisibleStream.value;
      expect(isVisible, true);

      bloc.dispose();
    });
  });

  group('Login Auth', () {
    stubSignIn(response) {
      when(auth.signInWithEmailAndPassword(
              email: 'mail@mail.com', password: '1234567'))
          .thenAnswer((_) => response);
    }

    stubSignInErr(response) {
      when(auth.signInWithEmailAndPassword(
              email: 'mail@mail.com', password: '1234567'))
          .thenThrow(response);
    }

    stubDoc() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('users')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document('mail@mail.com')).thenAnswer((_) => docRef);

      when(docRef.snapshots())
          .thenAnswer((_) => Future.value(MockDocumentSnapshot()).asStream());
    }

    test('success', () async {
      LoginBloc bloc = LoginBloc();

      stubSignIn(null);
      stubDoc();

      await bloc.loginUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.SUCCESS);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed platform exception', () async {
      LoginBloc bloc = LoginBloc();

      stubSignInErr(PlatformException(
          code: 'WRONG_EMAIL_PASS', message: 'Wrong password or email'));
      stubDoc();

      await bloc.loginUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed socket exception', () async {
      LoginBloc bloc = LoginBloc();

      stubSignInErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));
      stubDoc();

      await bloc.loginUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed exception', () async {
      LoginBloc bloc = LoginBloc();

      stubSignInErr(Exception(LocDelegate.currentLoc.error.exceptionError));
      stubDoc();

      await bloc.loginUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message,
          'Exception: ' + LocDelegate.currentLoc.error.exceptionError);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });
  });
}
