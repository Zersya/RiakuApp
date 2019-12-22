import 'package:connectivity/connectivity.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/geo_service.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CreatePostBloc extends BaseReponseBloc {
  PostService _servicePost;
  GeoService _geoService;

  BehaviorSubject<bool> _subjectIsConnect;
  BehaviorSubject<bool> _subjectIsNotEmpty;

  Address _currentLocation = Address();

  CreatePostBloc() {
    
    _servicePost = GetIt.I<PostService>();
    _geoService = GetIt.I<GeoService>();

    _subjectIsConnect = BehaviorSubject<bool>();
    _subjectIsNotEmpty = BehaviorSubject<bool>();
  }

  ValueStream<bool> get connectivityStream => _subjectIsConnect.stream;
  ValueStream<bool> get isNotEmptyStream => _subjectIsNotEmpty.stream;

  Stream<bool> get isAbletoSend =>
      _subjectIsNotEmpty.withLatestFrom(_subjectIsConnect, (a, b) => a && b);

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  Address get currentLocation => _currentLocation;


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

  Future fetchLocation() async {
    try {
      List<Address> addresses = await _geoService.fetchLocation();
      _currentLocation = addresses.first;
    } catch (err) {}
  }

  Future<Post> submitPost(String desc, String imgUrl, String timeEpoch) async {
    Post post = Post(_currentLocation.locality, super.user, desc, imgUrl, timeEpoch);

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
