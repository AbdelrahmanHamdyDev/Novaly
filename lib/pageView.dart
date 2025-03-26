import 'package:flutter/material.dart';
import 'package:novaly/View/HomeScreen.dart';
import 'package:novaly/View/SearchScreen.dart';

class pageViewController extends StatefulWidget {
  @override
  State<pageViewController> createState() => _pageViewControllerState();
}

class _pageViewControllerState extends State<pageViewController> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [homeScreen(), searchScreen()],
        onPageChanged: _onTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        enableFeedback: true,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper, color: Colors.white),
            label: "HeadLines",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: "Search",
            backgroundColor: Colors.black,
          ),
        ],
        onTap: _onTapped,
      ),
    );
  }
}
