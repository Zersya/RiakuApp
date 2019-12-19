import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/home/dashboard/dashboard_bloc.dart';
import 'package:riaku_app/utils/funcCommon.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemPost extends StatelessWidget {
  const ItemPost(
      {Key key,
      @required this.user,
      @required this.post,
      @required this.isUpload})
      : super(key: key);

  final Post post;
  final User user;
  final bool isUpload;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final timePost =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.createdAt));

    final DashboardBloc _dashboardBloc = Provider.of<DashboardBloc>(context);
    final myLike = _dashboardBloc.yourLike(post);

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isUpload)
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.surface),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator()),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(loc.common.uploading,
                          style: Theme.of(context).textTheme.body2)
                    ],
                  )),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(generateAvatar(user.id)),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      user.username,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          timeago.format(timePost),
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          post.location ?? '-',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (post.imgUrl.isNotEmpty)
            Image.network(
              this.post.imgUrl,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              post.description,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${post.likes?.length ?? 0} ${loc.dashboard.likesLabel}',
                      style: Theme.of(context).textTheme.overline,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    if (myLike > 0)
                      Text(
                        '+$myLike ${loc.dashboard.likesLabel}',
                        style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                Text('100 ${loc.dashboard.commentsLabel}',
                    style: Theme.of(context).textTheme.overline)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface))),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        _dashboardBloc.likePost(post);
                      },
                      child: Icon(
                        FontAwesomeIcons.signLanguage,
                        color: myLike > 0
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Colors.grey,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.comment,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
