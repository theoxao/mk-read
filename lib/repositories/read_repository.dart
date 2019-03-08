import 'package:dio/dio.dart';
import 'package:flutter_mk/common/commons.dart';
import 'package:flutter_mk/models/book.dart';
import 'package:flutter_mk/models/read_detail_models.dart';
import 'package:flutter_mk/models/user_book.dart';
import 'package:flutter_mk/repositories/request_wrap.dart';
import 'package:flutter/material.dart';

class ReadRepository {
  BuildContext context;

  ReadRepository(this.context);

  static Future<List<dynamic>> fetchTagList() async {
    print("requesting tag list");
    String path = host + "/read/tag/list";
    var response = await Dio(getOptions).get(path);
    return response.data['data'];
  }

  static Future<List<UserBook>> fetchShelfBook(String tag) async {
    print("requesting tag is $tag");
    if (tag == "全部") tag = "";
    String path = host + "/read/shelf/list?tag=$tag";
    var response = await Dio(getOptions).get(path);
    var data = response.data['data'];
    List<UserBook> result = [];
    for (var value in data) {
      result.add(UserBook.fromJsonMap(value));
    }
    return result;
  }

  static Future<List<Book>> fetchBookByIsbn(String isbn) async {
    print("requesting book is $isbn");
    String path = host + "/read/read/isbn/$isbn";
    var response = await Dio(getOptions).get(path);
    List<Book> result = [];
    for (var value in response.data['data']) {
      result.add(Book.fromJsonMap(value));
    }
    return result;
  }

  static Future fetchReadStat(String id) async {
    print("requesting read stat");
    String path = host + "/read/read/read_stat?id=$id";
    var response = await Dio(getOptions).get(path);
    print(response.data);
    return response.data['data'];
  }

  static Future<List<ReadProgress>> fetchReadProgress(
      String id, String offsetId, int size) async {
    print("requesting read progress id $id, offsetId $offsetId, size $size");
    String path =
        host + "/read/read/read_log?id=$id&offsetId=$offsetId&size=$size";
    var response = await Dio(getOptions).get(path);
    List<ReadProgress> list = [];
    for (var value in response.data['data']) {
      list.add(ReadProgress.fromJsonMap(value));
    }
    return list;
  }

  static Future<List<ReadExcerpt>> fetchReadExcerpt(
      String id, int page, int size) async {
    print("request read excerpt id $id");
    String path = host + "/read/excerpt/index?bookId=$id&page=$page&size=$size";
    var response = await Dio(getOptions).get(path);
    List<ReadExcerpt> list = [];
    for (var value in response.data['data']) {
      list.add(ReadExcerpt.fromJsonMap(value));
    }
    return list;
  }

  ///try not use path param
  Future<String> readOperation(
      String id, String refBook, int operation, String currentPage,
      {int type = 1}) async {
    String path = host +
        "/read/read/read_operate?operation=$operation&refBook=$refBook&type=$type&currentPage=$currentPage";
    if (id != "") path += "&id=$id";
    print("read operation request ,path: $path");
    var options = getOptions;
    options.path = path;
    Response response = await EventRequest(context).post(options);
    print("read operation response $response");
    return response.data["data"]["id"];
  }
}
