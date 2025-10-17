import 'package:al_anime_creator/core/widgets/bottom_navigator_bar_widget.dart';
import 'package:al_anime_creator/features/demo/demo_view.dart';
import 'package:al_anime_creator/features/feed/view/feed_view.dart';
import 'package:al_anime_creator/features/profile/profile_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'HomeRoute')
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  // Alt menüde tıklanan indeksi CustomBottomNavBar'dan almak için callback fonksiyonu
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DemoView(), // Home tab
          FeedView(), // Feed tab  
          ProfileView(), // Profile tab
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}