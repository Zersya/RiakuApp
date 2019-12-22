import 'package:get_it/get_it.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/services/post_service.dart';

class PostHelper extends BaseReponseBloc {
  PostService _servicePost;

  PostHelper(){
    _servicePost = GetIt.I<PostService>();
  }

  PostService get servicePost => _servicePost;

  Future<Post> likePost(Post post, int index, bool isLike) async {
    post.likes = List.from(post.likes);

    if (isLike) {
      post.likes.add(super.user.id);
    } else {
      post.likes.removeWhere((like) => like == super.user.id);
    }

    MyResponse response = await _servicePost.likePost(post);
    this.subjectResponse.sink.add(response);

    return post;
  }

  int yourLike(Post post) {
    int counter = 0;
    post.likes?.forEach((str) {
      if (str == super.user.id) counter = counter + 1;
    });
    return counter;
  }

  Future deletePost(Post post) async {
    MyResponse response = await _servicePost.deletePost(post);
    this.subjectResponse.sink.add(response);
  }

  bool isAble2Delete(Post post) {
    int delayTimeMinute = 10;

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.createdAt));

    bool data =
        (dateTime.difference(DateTime.now()).inMinutes.abs() < delayTimeMinute);
    return data;
  }
}