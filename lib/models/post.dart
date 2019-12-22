import 'user.dart';

class Post {
  User user;
  String id;
  List likes;
  int countComment;

  final String description;
  final String imgUrl;
  final String createdAt;
  final String location;

  Post(this.location, this.user, this.description, this.imgUrl, this.createdAt,
      {this.id, this.likes, this.countComment});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      map['location'],
      User.fromMap(map['user']),
      map['description'],
      map['imgUrl'],
      map['createdAt'],
      id: map['id'],
      likes: map['likes'],
      countComment: map['countComment']
    );
  }

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'location': this.location,
        'user': this.user.toMap(),
        'description': this.description,
        'imgUrl': this.imgUrl,
        'createdAt': this.createdAt,
        'likes': this.likes ?? List(),
        'countComment': this.countComment ?? 0
      };
}
