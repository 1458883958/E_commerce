import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('获取首页数据'),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              List<Map> carousel = (data['data']['slides'] as List).cast();
              List<Map> navigator = (data['data']['category'] as List).cast();
              return Column(children: <Widget>[
                Carousel(
                  carouselData: carousel,
                ), // 轮播
                Container(
                  color: Color.fromARGB(255, 239, 239, 239),
                  height: ScreenUtil.getInstance().setHeight(12),
                ), // 分割线
                TopNavigator(
                  navigatorData: navigator,
                ), // 顶部导航
              ]);
            } else {
              return Center(
                child: Text('暂无数据'),
              );
            }
          },
        ),
      ),
    );
  }
}

/*
*  首页轮播组件
*
*/
class Carousel extends StatelessWidget {
  // 轮播数据
  final List carouselData;

  Carousel({Key key, this.carouselData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(333),
      width: ScreenUtil.getInstance().setWidth(750),
      child: Swiper(
        itemCount: carouselData.length,
        itemBuilder: (context, index) {
          return Image.network(
            carouselData[index]['image'],
            fit: BoxFit.fill,
          );
        },
        pagination: SwiperPagination(), // 小圆点
        autoplay: true,
      ),
    );
  }
}

/*
*  顶部导航组件
*
*/
class TopNavigator extends StatelessWidget {
  final List navigatorData;

  TopNavigator({Key key, this.navigatorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (navigatorData.length > 10) {
      navigatorData.removeRange(10, navigatorData.length);
    }
    return Container(
      height: ScreenUtil.getInstance().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: _navigator(context),
    );
  }

  Widget _navigator(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(5.0),
      itemCount: navigatorData.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemBuilder: (context, index) {
        return InkWell(
          child: Column(
            children: <Widget>[
              Image.network(
                navigatorData[index]['image'],
                fit: BoxFit.fill,
                width: ScreenUtil.getInstance().setWidth(95),
              ),
              Text(
                '${navigatorData[index]['mallCategoryName']}',
              ),
            ],
          ),
          onTap: () {
            print('点击了${navigatorData[index]['mallCategoryName']}');
          },
        );
      },
    );
  }
}
