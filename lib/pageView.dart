import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novaly/View/BookmarkScreen.dart';
import 'package:novaly/View/HomeScreen.dart';
import 'package:novaly/View/SearchScreen.dart';

class pageViewController extends StatefulWidget {
  @override
  State<pageViewController> createState() => _pageViewControllerState();
}

class _pageViewControllerState extends State<pageViewController> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onTapped,
          children: [homeScreen(), searchScreen(), bookmarkScreen()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTapped,
          indicatorColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.3),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.newspaper),
              selectedIcon: Icon(Icons.newspaper),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: '',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(Icons.bookmark),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
