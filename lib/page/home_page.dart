import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  var showToast = '正在等待！';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('post小案例'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: false,
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  labelText: '类型',
                  helperText: '请输入类型',
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_controller.text == '') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('输入类型为空'),
                          );
                        });
                  } else {
                    _postHttp(_controller.text).then((value) {
                      setState(() {
                        showToast = value['data']['name'];
                      });
                    });
                  }
                },
                child: Text('点击获取服务'),
              ),
              Center(
                child: Text(
                  showToast,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _postHttp(String name) async {
    print('开始获取...........');
    var data = {'name': name};
    try {
      Response response = await Dio().post(
          'https://www.easy-mock.com/mock/5cd2871821b32328e69012d6/example/post_test',
          queryParameters: data);
      print('${response.data}');
      return response.data;
    } catch (e) {
      return print(e.toString());
    }
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
