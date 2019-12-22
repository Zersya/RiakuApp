import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockFirestore extends Mock implements Firestore {}

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

class MockValStream<MockQuerySnapshot> extends Mock
    implements Stream<QuerySnapshot> {}
    
class MockQuery extends Mock implements Query {}
