import 'package:flutter/material.dart';
import '../models/user_book.dart';
import '../common/commons.dart';

class ShelfBookView extends StatelessWidget {
  final UserBook userBook;

  ShelfBookView(this.userBook);

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
                  elevation: 0,
                  child: Image.network(
                    userBook.cover,
                    width: 100,
                    height: 125,
                    scale: 0.8,
//            fit: BoxFit.fill,
                  )),
          Text(
            userBook.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: primaryTextSize),
          ),
          Text(
            userBook.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: secondTextSize),
          )
        ],
      ),
    );
  }
}
