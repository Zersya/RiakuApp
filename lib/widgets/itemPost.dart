import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/helper/postHelper.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/utils/funcCommon.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemPost extends StatelessWidget {
  const ItemPost(
      {Key key,
      @required this.index,
      @required this.post,
      @required this.isUpload,
      @required this.postHelper})
      : super(key: key);

  final Post post;
  final bool isUpload;
  final int index;
  final PostHelper postHelper;

  void _settingModalBottomSheet(context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.delete),
                      title: new Text(loc.common.delete),
                      onTap: () {
                        postHelper.deletePost(post);
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final timePost =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.createdAt));

    final myLike = postHelper.yourLike(post);
    User user = post.user;

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isUpload) MiniLoadingBar(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(generateAvatar(user.id)),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              user.username,
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            if (postHelper.isAble2Delete(post))
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  onTap: () {
                                    _settingModalBottomSheet(context);
                                  },
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.more_horiz)),
                                ),
                              )
                          ],
                        ),
                      ),
                      subtitle: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            timeago.format(timePost,
                                    locale: Locale.cachedLocaleString) ??
                                '-',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                post.description,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
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
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border(right: BorderSide(color: Colors.grey))),
                        child: InkWell(
                          onTap: () {
                            postHelper.likePost(post, index, true);
                          },
                          onLongPress: () {
                            postHelper.likePost(post, index, false);
                          },
                          child: Icon(
                            FontAwesomeIcons.signLanguage,
                            color: myLike > 0
                                ? Theme.of(context).colorScheme.primaryVariant
                                : Colors.grey,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border(left: BorderSide(color: Colors.grey))),
                        child: InkWell(
                          onTap: () {
                            postHelper.likePost(post, index, true);
                          },
                          onLongPress: () {
                            postHelper.likePost(post, index, false);
                          },
                          child: Icon(
                            FontAwesomeIcons.solidComment,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MiniLoadingBar extends StatelessWidget {
  const MiniLoadingBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
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
    );
  }
}
