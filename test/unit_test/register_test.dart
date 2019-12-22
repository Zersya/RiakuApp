import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/auth/register/register_bloc.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/helper/loc_delegate.dart';
import 'package:riaku_app/helper/locator.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/utils/strCode.dart';
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

class MockDocumentSnapshotNULL extends Mock implements DocumentSnapshot {
  String documentID = '123';
  Map<String, dynamic> data;
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

    locator(firestore, true, auth: auth);

    locDelegate = LocDelegate();
    locDelegate.load(Locale('en'));
  });

  group('Register Auth', () {
    stubRegister(response) {
      when(auth.createUserWithEmailAndPassword(
              email: 'mail@mail.com', password: '1234567'))
          .thenAnswer((_) => response);
    }

    stubRegisterErr(response) {
      when(auth.createUserWithEmailAndPassword(
              email: 'mail@mail.com', password: '1234567'))
          .thenThrow(response);
    }

    stubDoc(DocumentSnapshot response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('users')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document('mail@mail.com')).thenAnswer((_) => docRef);

      when(docRef.snapshots())
          .thenAnswer((_) => Future.value(response).asStream());
    }

    test('success registered ', () async {
      RegisterBloc bloc = RegisterBloc();

      stubDoc(MockDocumentSnapshotNULL());
      stubRegister(null);

      await bloc.registerUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.SUCCESS);
      expect(response.message, LocDelegate.currentLoc.success.successCreate);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed already registered ', () async {
      RegisterBloc bloc = RegisterBloc();

      stubDoc(MockDocumentSnapshot());
      stubRegister(null);

      await bloc.registerUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(
          response.message, LocDelegate.currentLoc.error.emailRegisteredError);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed platform exception', () async {
      RegisterBloc bloc = RegisterBloc();

      stubRegisterErr(PlatformException(
          code: kEmailRegisteredCode,
          message: LocDelegate.currentLoc.error.emailRegisteredError));
      stubDoc(MockDocumentSnapshot());

      await bloc.registerUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed socket exception', () async {
      RegisterBloc bloc = RegisterBloc();

      stubRegisterErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));
      stubDoc(MockDocumentSnapshotNULL());

      await bloc.registerUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });

    test('failed exception', () async {
      RegisterBloc bloc = RegisterBloc();

      stubRegisterErr(Exception(LocDelegate.currentLoc.error.exceptionError));
      stubDoc(MockDocumentSnapshotNULL());

      await bloc.registerUser(User('mail@mail.com', password: '1234567'));
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message,
          'Exception: ' + LocDelegate.currentLoc.error.exceptionError);
      expect(bloc.stateStream, emits(FormState.IDLE));

      bloc.dispose();
    });
  });
}
