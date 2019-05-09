import 'package:flutter/material.dart';
import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showStr = '正在获取数据';

  @override
  void initState() {
    getHomePageContent().then((value) {
      setState(() {
        showStr = value.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('获取首页数据'),
        ),
        body: SingleChildScrollView(
          child: Text(
            showStr,
          ),
        ),
      ),
    );
  }
}
