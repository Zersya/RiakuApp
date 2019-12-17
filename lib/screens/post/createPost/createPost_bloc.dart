import 'package:connectivity/connectivity.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostBloc extends BaseReponseBloc {
  PostService _servicePost;
  BehaviorSubject<bool> _subjectIsConnect;
  BehaviorSubject<bool> _subjectIsNotEmpty;

  CreatePostBloc() {
    _servicePost = PostService();
    _subjectIsConnect = BehaviorSubject<bool>();
    _subjectIsNotEmpty = BehaviorSubject<bool>();
  }

  ValueStream<bool> get connectivityStream => _subjectIsConnect.stream;
  ValueStream<bool> get isNotEmptyStream => _subjectIsNotEmpty.stream;

  Stream<bool> get isAbletoSend =>
      _subjectIsNotEmpty.withLatestFrom(_subjectIsConnect, (a, b) => a && b);

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  void setConnectivity(ConnectivityResult val) {
    if (val != ConnectivityResult.none)
      _subjectIsConnect.sink.add(true);
    else
      _subjectIsConnect.sink.add(false);
  }

  void setIsNotEmpty(String val) {
    if (val.isNotEmpty) {
      _subjectIsNotEmpty.sink.add(true);
    } else {
      _subjectIsNotEmpty.sink.add(false);
    }
  }

  Future<Post> submitPost(String desc, String imgUrl, String timeEpoch) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);
   
    User user = User(email, id: id, username: username);
    Post post = Post(user, desc, imgUrl, timeEpoch);

    MyResponse response = await _servicePost.createPost(post);
    this.subjectResponse.sink.add(response);

    return post;
  }

  @override
  void dispose() {
    super.dispose();
    _subjectIsConnect.close();
    _subjectIsNotEmpty.close();
  }
}
