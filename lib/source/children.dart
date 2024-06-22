import 'package:flutter/material.dart';
import 'package:learn/pages/children/activities_v1.dart';
import 'package:learn/widgets/global/nav_bar.dart';
import 'package:learn/pages/children/home.dart';
import 'package:learn/pages/children/activities.dart';
import 'package:learn/pages/children/connie.dart';
import 'package:learn/classes.dart';
import 'package:provider/provider.dart';

class ChildrenMain extends StatefulWidget {
  @override
  _ChildrenMainState createState() => _ChildrenMainState();
}

class _ChildrenMainState extends State<ChildrenMain> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  ValueNotifier<double> pagePosition = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _pageController.addListener(() {
      if (pagePosition.value != _pageController.page) {
        setState(() {
          pagePosition.value = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut,);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pageOptions = [
      ChildrenHomePage(pagePosition: pagePosition),
      ChildrenActivitiesPage(pagePosition: pagePosition),
      Activities_V1(),
      MascotPage(pageController: _pageController),
    ];

    List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home, 'name': 'Home'},
      {'icon': Icons.gamepad, 'name': 'Atividades'},
      {'icon': Icons.abc_rounded, 'name': 'Atividades'},
      {'icon': Icons.network_ping_outlined, 'name': 'Mascote'},
    ];

    final children = ModalRoute.of(context)?.settings.arguments as Children;
    return ChangeNotifierProvider<VolatileChildren>(
        create: (context) => VolatileChildren(children: children),
        child: Scaffold(
          body: Stack(children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _pageOptions,
            ),
            if (_selectedIndex != 3)
              Positioned(
                  left: 32,
                  right: 32,
                  bottom: 32,
                  child: LearnNavBar(
                    onItemTapped: _onItemTapped,
                    navItems: navItems,
                  ))
          ]),
        ));
  }
}
