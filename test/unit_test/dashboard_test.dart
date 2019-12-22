import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/home/dashboard/dashboard_bloc.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/locator.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQuery extends Mock implements Query {}

class MockBehavSubject<MockQuerySnapshot> extends Mock
    implements BehaviorSubject<QuerySnapshot> {}

class MockValStream<MockQuerySnapshot> extends Mock
    implements Stream<QuerySnapshot> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockFirestore firestore;
  LocDelegate locDelegate;
  MockQuery query;
  MockValStream snapshots;

  Post post;

  setUpAll(() {
    locator(firestore, true);
    SharedPreferences.setMockInitialValues({
      kEmailKey: 'mail@mail.com',
      kIdKey: 'mail@mail.com',
      kUsernameKey: 'mail-mail'
    });

    firestore = MockFirestore();
    query = MockQuery();
    snapshots = MockValStream();

    locator(firestore, true);

    locDelegate = LocDelegate();
    locDelegate.load(Locale('en'));

    post = Post(
        'home', User('mail@mail.com', id: 'mail@mail.com'), 'desc', null, '123',
        likes: ['mail@mail.com', 'mail@mail.com']);
  });

  group('Dashboard UI', () {
    test('your post likes', () async {
      DashboardBloc bloc = DashboardBloc();
      await bloc.fetchUser();

      int counter = bloc.yourLike(post);

      expect(counter, 2);

      bloc.dispose();
    });

    test('add post progress', () async {
      DashboardBloc bloc = DashboardBloc();

      bloc.setListData(post);

      List<Post> posts = bloc.postsStream.value;
      expect(posts.length, 1);
      expect(posts.first.location, 'home');

      int counter = bloc.onUploadIdxStream.value;
      expect(counter, 0);

      bloc.dispose();
    });
  });

  group('Dashboard', () {
    stubDoc() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      when(colRef.orderBy(any)).thenAnswer((_) => query);

      when(query.snapshots()).thenAnswer((_) => snapshots);
    }

    stubDocErr(response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      when(colRef.orderBy(any)).thenAnswer((_) => query);

      when(query.snapshots()).thenThrow(response);
    }

    stubCreateLike() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.setData(any)).thenAnswer((_) => null);
    }

    stubCreateLikeErr(response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.setData(any)).thenThrow(response);
    }

    test('like post', () async {
      DashboardBloc bloc = DashboardBloc();

      await bloc.fetchUser();
      bloc.setListData(post);

      stubCreateLike();

      await bloc.likePost(post, 0, true);
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.message, LocDelegate.currentLoc.success.successCreate);
    });

    test('unlike post', () async {
      DashboardBloc bloc = DashboardBloc();

      await bloc.fetchUser();
      bloc.setListData(post);

      stubCreateLike();

      await bloc.likePost(post, 0, false);
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.message, LocDelegate.currentLoc.success.successCreate);
    });

    test('like post exception', () async {
      DashboardBloc bloc = DashboardBloc();

      await bloc.fetchUser();
      bloc.setListData(post);

      stubCreateLikeErr(Exception(LocDelegate.currentLoc.error.exceptionError));

      await bloc.likePost(post, 0, true);
      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.exceptionError);
    });

    test('like post socketexception', () async {
      DashboardBloc bloc = DashboardBloc();

      await bloc.fetchUser();
      bloc.setListData(post);

      stubCreateLikeErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));

      await bloc.likePost(post, 0, true);
      MyResponse response = bloc.subjectResponse.stream.value;
      
      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);
    });

    test('fetch user', () async {
      DashboardBloc bloc = DashboardBloc();
      User user = await bloc.fetchUser();

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      user = bloc.userStream.value;
      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      bloc.dispose();
    });

    test('fetch data', () async {
      DashboardBloc bloc = DashboardBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDoc();

      await bloc.fetchData();

      MyResponse response = bloc.subjectResponse.stream.value;
      expect(response.responseState, ResponseState.SUCCESS);
      expect(response.message, LocDelegate.currentLoc.success.successCreate);
    });

    test('fetch data exception', () async {
      DashboardBloc bloc = DashboardBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDocErr(Exception(LocDelegate.currentLoc.error.exceptionError));

      await bloc.fetchData();

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.exceptionError);
    });

    test('fetch data socketexception', () async {
      DashboardBloc bloc = DashboardBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDocErr(SocketException(LocDelegate.currentLoc.error.connectionError));

      await bloc.fetchData();

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);
    });
  });
}
