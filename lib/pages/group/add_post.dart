import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mk/common/commons.dart';
import 'package:flutter_mk/helper/ensure_visiable_helper.dart';
import 'package:flutter_mk/repositories/group_repository.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  final groupId;

  const NewPostPage({Key key, this.groupId}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  List<File> files = [];
  var contentNode = FocusNode();
  var contentCtrl = TextEditingController();
  List<Widget> rows = [];
  var accepted = false;

  @override
  Widget build(BuildContext context) {
    rows = files.map<Widget>((file) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Draggable(
          maxSimultaneousDrags: 1,
          onDragStarted: () {},
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: window.physicalSize.width / 9,
            height: window.physicalSize.width / 9,
          ),
          feedback: Image.file(
            file,
            fit: BoxFit.cover,
            width: window.physicalSize.width / 8.8,
            height: window.physicalSize.width / 8.8,
          ),
          childWhenDragging: Container(
            width: window.physicalSize.width / 9,
            height: window.physicalSize.width / 9,
          ),
          data: [
            "image"
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("新发言"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                EnsureVisibleWhenFocused(
                  focusNode: contentNode,
                  child: Card(
                    child: Column(children: <Widget>[
                      TextField(
                        controller: contentCtrl,
                        maxLines: 8,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                        focusNode: contentNode,
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: "这一刻的想法...",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none))),
                      ),
                      gridView(rows)
                    ]),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    GroupRepository(context)
                        .createPost(widget.groupId, contentCtrl.text, files)
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("提交"),
                ),
                DragTarget(
                  builder: (BuildContext context, List candidateData,
                      List rejectedData) {
                    return Container(
                      color: Colors.red,
                      height: 48,
                      child:Text("拖到此处删除"),
                    );
                  },
                  onWillAccept: (data){
                    print(data);
                    return true;
                  },
                  onAccept:(data){
                    accepted =true;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource source) async {
    try {
      var image = await ImagePicker.pickImage(source: source);
      setState(() {
        files.add(image);
      });
    } catch (e) {
      print("select image cancelled");
    }
  }

  Widget gridView(List<Widget> list) {
    if (list.length < 9) {
      rows.add(GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(64.0),
                child: Center(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                "拍照",
                                style: bookNameStyle,
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            getImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                "从相册选择",
                                style: bookNameStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Image.asset(
          "image/ic_add_cover.png",
          width: windowWidth / 9,
          height: windowWidth / 9,
        ),
      ));
    }

    var array = [];

    for (var i = 0; i < list.length; i += 3) {
      var value =
      list.sublist(i, i + 3 < list.length ? i + 3 : list.length).toList();
      array.add(value);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: array.map((rows) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rows,
        );
      }).toList(),
    );
  }
}
