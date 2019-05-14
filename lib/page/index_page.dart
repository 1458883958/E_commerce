import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'assort_page.dart';
import 'cart_page.dart';
import 'plus_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // 所有的item
  final List<BottomNavigationBarItem> _bottomBarItems = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心'),
    )
  ];

  // 主页对应的四个页面
  List<Widget> _pages = [];

  // 当前页面的下标
  int _currentIndex = 0;

  // 当前页
  var _currentPage;

  @override
  void initState() {
    _pages
      ..add(HomePage())
      ..add(AssortPage())
      ..add(CartPage())
      ..add(PlusPage());
    _currentPage = _pages[_currentIndex];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//    print('像素密度:${ScreenUtil.pixelRatio}');
//    print('设备高:${ScreenUtil.screenHeight}');
//    print('设备宽:${ScreenUtil.screenWidth}');
    return Scaffold(
      // 设置当前页面的主体
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 固定位置，3个以上itemBar禁止动画
        type: BottomNavigationBarType.fixed,
        // 所有ItemBar
        items: _bottomBarItems,
        // 当前下标
        currentIndex: _currentIndex,
        // 点击切换
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _currentPage = _pages[_currentIndex];
          });
        },
      ),
    );
  }
}
