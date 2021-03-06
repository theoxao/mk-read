import 'package:flutter/material.dart';
import 'package:flutter_mk/models/post_model.dart';

class ActivityView extends StatelessWidget {
  final Activity activity;

  const ActivityView({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.network(
          activity.avatarUrl,
          width: 20,
          height: 20,
        ),
        Text(activity.nickName),
        Text(activity.operation),
        //TODO
      ],
    );
  }
}
