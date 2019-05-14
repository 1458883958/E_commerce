import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import '../config/service_url.dart';
import '../config/http_header.dart';

/*
*  获取首页内容
* 
* */
Future getHomePageContent() async {
  try {
    print('开始请求首页数据...............');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    var data = {'lon': 115.02932, 'lat': 35.76189};
    response = await dio.post(servicePath['homePageContent'], data: data);
    if (response.statusCode == 200) {
      //print(response.data.toString());
      return response.data;
    } else {
      throw Exception('服务器异常，请稍后再试！');
    }
  } catch (e) {
    return print('Error ============> $e');
  }
}


Future test() async {
  try {
    print('开始请求Bilibili数据...............');
    Response response;
    Dio dio = Dio();
    dio.options.headers = header;
    response = await dio.get(url);
    if (response.statusCode == 200) {
      print(response.data.toString());
      return response.data;
    } else {
      throw Exception('服务器异常，请稍后再试！');
    }
  } catch (e) {
    return print('Error ============> $e');
  }
}
