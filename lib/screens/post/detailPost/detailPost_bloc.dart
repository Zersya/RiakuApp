import 'package:riaku_app/helper/postHelper.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/screens/post/detailPost/detailPost_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
class DetailPostBloc extends PostHelper{
  BehaviorSubject<Post> _subjectPost;
  
  DetailPostBloc(){
    _subjectPost = BehaviorSubject<Post>();
  }

  ValueStream<Post> get postStream => _subjectPost.stream;

  @override
  Future<Post> likePost(Post post, int index, bool isLike) async {
    _subjectPost.sink.add(post);
    
    Post _post = await super.likePost(post, index, isLike);

    return _post;
  }

}