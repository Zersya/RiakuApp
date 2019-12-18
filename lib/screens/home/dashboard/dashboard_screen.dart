import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/screens/home/dashboard/dashboard_bloc.dart';
import 'package:riaku_app/screens/home/dashboard/widgets/formPost.dart';
import 'package:riaku_app/screens/home/dashboard/widgets/itemPost.dart';
import 'package:riaku_app/screens/post/createPost/createPost_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  CreatePostBloc _createPostBloc = CreatePostBloc();
  DashboardBloc _dashboardBloc = DashboardBloc();

  @override
  void initState() {
    _createPostBloc.responseStream.listen((val) {
      _dashboardBloc.decreaseOnUploadIdx();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(val.message),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ));
    });
    _dashboardBloc.fetchData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _createPostBloc.dispose();
    // _dashboardBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            MultiProvider(
              providers: [
                Provider.value(
                  value: _createPostBloc,
                ),
                Provider.value(
                  value: _dashboardBloc,
                ),
              ],
              child: FormStatus(),
            ),
            StreamBuilder<List<Post>>(
                stream: _dashboardBloc.postsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return ShimmerLoading();
                  List<Post> currentList = snapshot.data;
                  return ListView.separated(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: currentList.length,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 5,
                        color: Theme.of(context).colorScheme.surface,
                      );
                    },
                    itemBuilder: (context, index) {
                      return StreamBuilder<int>(
                          stream: _dashboardBloc.onUploadIdxStream,
                          initialData: 0,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return ShimmerLoading();
                            return Provider.value(
                              value: _dashboardBloc,
                              child: ItemPost(
                                  isUpload: index < snapshot.data,
                                  user: currentList[index].user,
                                  post: currentList[index]),
                            );
                          });
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: Theme.of(context).colorScheme.onSurface,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0)),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.0)),
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0)),
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
