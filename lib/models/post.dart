import 'package:riaku_app/models/user.dart';

class Post {
  User user;
  final String id;
  final String description;
  final String imgUrl;
  final String createdAt;

  Post(this.user, this.description, this.imgUrl, this.createdAt, {this.id});

  void setUser(User user){
    this.user = user;
  }

  factory Post.formMap(Map<String, dynamic> map) {
    return Post(User.fromMap(map['user']), map['description'], map['imgUrl'],
        map['createdAt'],
        id: map['id']);
  }

  Map<String, dynamic> toMap() => {
        'user': this.user.toMap(),
        'description': this.description,
        'imgUrl': this.imgUrl,
        'createdAt': this.createdAt
      };
}
