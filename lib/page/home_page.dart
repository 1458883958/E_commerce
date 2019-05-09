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
              return Column(children: <Widget>[
                Carousel(
                  carouselData: carousel,
                ),
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
*  首页轮播
*
*/
class Carousel extends StatelessWidget {
  // 轮播数据
  final List carouselData;

  Carousel({Key key, this.carouselData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
    print('像素密度:${ScreenUtil.pixelRatio}');
    print('设备高:${ScreenUtil.screenHeight}');
    print('设备宽:${ScreenUtil.screenWidth}');
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
