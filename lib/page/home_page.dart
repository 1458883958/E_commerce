import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
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
              var map = data['data'];
              List<Map> carousel = (map['slides'] as List).cast();
              List<Map> navigator = (map['category'] as List).cast();
              List<Map> recommend = (map['recommend'] as List).cast();
              String bannerUrl = map['advertesPicture']['PICTURE_ADDRESS'];
              var shopInfo = map['shopInfo'];
              List preferential = [
                map['integralMallPic']['PICTURE_ADDRESS'],
                map['saoma']['PICTURE_ADDRESS'],
                map['newUser']['PICTURE_ADDRESS']
              ];
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
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
                    Container(
                      color: Color.fromARGB(255, 239, 239, 239),
                      height: ScreenUtil.getInstance().setHeight(12),
                    ),
                    AdBanner(
                      bannerUrl: bannerUrl,
                    ), // 广告
                    OnTouchCall(
                      shopInfo: shopInfo,
                    ), // 一键拨打电话
                    Container(
                      color: Color.fromARGB(255, 239, 239, 239),
                      height: ScreenUtil.getInstance().setHeight(12),
                    ),
                    Preferential(
                      preferential: preferential,
                    ),
                    Container(
                      color: Color.fromARGB(255, 239, 239, 239),
                      height: ScreenUtil.getInstance().setHeight(16),
                    ),
                    Recommend(
                      recommendList: recommend,
                    ), // 商品推荐
                    FloorTitle(
                      titleUrl: map['floor1Pic']['PICTURE_ADDRESS'],
                    ), // 楼层
                    FloorContent(
                      goods: map['floor1'],
                    ),
                    FloorTitle(
                      titleUrl: map['floor2Pic']['PICTURE_ADDRESS'],
                    ),
                    FloorContent(
                      goods: map['floor2'],
                    ),
                    FloorTitle(
                      titleUrl: map['floor3Pic']['PICTURE_ADDRESS'],
                    ),
                    FloorContent(
                      goods: map['floor3'],
                    ),
                  ],
                ),
              );
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

  @override
  bool get wantKeepAlive => true;
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

/*
*  广告条组件
*
*/
class AdBanner extends StatelessWidget {
  // 广告条图片地址
  final String bannerUrl;

  AdBanner({Key key, this.bannerUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Image.network(
            bannerUrl,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}

/*
*  一键拨打组件
*
*/
class OnTouchCall extends StatelessWidget {
  final Map shopInfo;

  OnTouchCall({Key key, this.shopInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _showDialog(context);
        },
        child: Column(
          children: <Widget>[
            Image.network(
              shopInfo['leaderImage'],
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('注意'),
          content: Text('是否拨打电话给${shopInfo['leaderPhone']}'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '取消',
              ),
            ),
            FlatButton(
                onPressed: () {
                  _launcherURL();
                  Navigator.pop(context);
                },
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        );
      },
    );
  }

  void _launcherURL() async {
    String url = 'tel:${shopInfo['leaderPhone']}';
    // 判断是否可发射(url是否符合)
    if (await canLaunch(url)) {
      // 发射
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

/*
*  限时优惠
*
*/
class Preferential extends StatelessWidget {
  final List preferential;

  const Preferential({Key key, this.preferential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(
            preferential.length,
            (index) => Image.network(
                  preferential[index],
                  fit: BoxFit.fill,
                )),
      ),
    );
  }
}

/*
*  商品推荐
*
*/
class Recommend extends StatelessWidget {
  final List recommendList;

  const Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题
  Widget _title() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('商品推荐', style: TextStyle(color: Colors.pink)),
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ))),
    );
  }

  // 推荐商品单独的项
  Widget _item(index) {
    return InkWell(
      child: Container(
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text('￥${recommendList[index]['price']}',
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey)),
          ],
        ),
        padding: EdgeInsets.all(8.0),
        width: ScreenUtil.getInstance().setWidth(250),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                right: BorderSide(
              color: Colors.black12,
              width: 1,
            ))),
      ),
      onTap: () {
        print('跳转');
      },
    );
  }

  // 横向列表
  Widget _list() {
    return Container(
      height: ScreenUtil.getInstance().setHeight(330),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _title(),
          _list(),
        ],
      ),
    );
  }
}

/*
*  楼层标题组件
*
*/
class FloorTitle extends StatelessWidget {
  final String titleUrl;

  const FloorTitle({Key key, this.titleUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(
        titleUrl,
        fit: BoxFit.fill,
      ),
    );
  }
}

/*
*  楼层内容组件
*
*/
class FloorContent extends StatelessWidget {
  final List goods;

  const FloorContent({Key key, this.goods}) : super(key: key);

  // 第一项
  Widget _firstItem(Map good) {
    return Container(
      width: ScreenUtil.getInstance().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了${good['goodsId']}');
        },
        child: Container(
          child: Image.network(
            good['image'],
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  // 第一行
  Widget _head() {
    return Row(
      children: <Widget>[
        _firstItem(goods[0]),
        Column(
          children: <Widget>[
            _firstItem(goods[1]),
            _firstItem(goods[2]),
          ],
        ),
      ],
    );
  }

  // 最后一行
  Widget _end() {
    return Row(
      children: <Widget>[
        _firstItem(goods[3]),
        _firstItem(goods[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _head(),
          _end(),
        ],
      ),
    );
  }
}
