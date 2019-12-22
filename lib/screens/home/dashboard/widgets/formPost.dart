import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/home/dashboard/dashboard_bloc.dart';
import 'package:riaku_app/screens/post/createPost/createPost_bloc.dart';
import 'package:riaku_app/utils/funcCommon.dart';
import 'package:riaku_app/helper/router.dart';

class FormStatus extends StatelessWidget {
  const FormStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final _createPostBloc = Provider.of<CreatePostBloc>(context);
    final _dashboardBloc = Provider.of<DashboardBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              StreamBuilder<User>(
                  stream: _dashboardBloc.userStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(generateAvatar(snapshot.data.id)),
                      );
                    return Container();
                  }),
              SizedBox(width: 16),
              Expanded(
                  child: OutlineButton(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.onSurface),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                highlightColor: Theme.of(context).colorScheme.onSurface,
                highlightedBorderColor: Theme.of(context).colorScheme.onSurface,
                splashColor: Theme.of(context).colorScheme.onSurface,
                hoverColor: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  Navigator.pushNamed(context, Router.kRouteAddPost,
                          arguments: _createPostBloc)
                      .then((val) {
                    if (val != null) {
                      Post post = val;
                      post.user = _dashboardBloc.user;
                      _dashboardBloc.setListData(post);
                    }
                  });
                },
                child: Text(
                  loc.post.hintPost,
                  style: Theme.of(context).textTheme.overline,
                ),
              ))
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 8.0),
          //   decoration: BoxDecoration(
          //       shape: BoxShape.rectangle,
          //       border: Border(
          //           top: BorderSide(
          //               color: Theme.of(context).colorScheme.onSurface))),
          //   child: Row(
          //     children: <Widget>[
          //       Expanded(
          //         flex: 1,
          //         child: Icon(Icons.add_a_photo),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
