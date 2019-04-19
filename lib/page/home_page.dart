import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getHttp();
    return Scaffold(
      body: Center(
        child: Text('HomePage'),
      ),
    );
  }

  void _getHttp() async {
    try {
      Response response = await Dio().get(
          'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian');
      return print(response);
    } catch (e) {
      return print(e);
    }
  }
}
