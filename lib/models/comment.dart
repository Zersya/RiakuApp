import 'package:cloud_firestore/cloud_firestore.dart';

import 'post.dart';
import 'user.dart';

class Comment {
  final User user;
  final String createdAt;
  final String message;
  DocumentReference ref;

  Comment(this.user, this.createdAt, this.message, {this.ref});

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
      User.fromMap(map['user']),
      map['createdAt'],
      map['message'],
      ref: map['docRef']);

  Map<String, dynamic> toMap() => {
        'user': this.user.toMap(),
        'createdAt': this.createdAt,
        'message': this.message,
        'docRef': this.ref,
      };
}
