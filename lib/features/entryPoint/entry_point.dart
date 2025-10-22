import 'dart:math';

import 'package:al_anime_creator/features/entryPoint/menu.dart';
import 'package:al_anime_creator/features/help/help_view.dart';
import 'package:al_anime_creator/features/screens/view/notification_view.dart';
import 'package:al_anime_creator/features/profile/profile_view.dart';
import 'package:al_anime_creator/features/screens/view/search_view.dart';
import 'package:al_anime_creator/features/screens/view/timer_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/story_history_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/favorites_view.dart';
import 'package:al_anime_creator/features/storygeneration/view/story_generation_view.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'widgets/menu_btn.dart';
import 'widgets/side_bar.dart';

@RoutePage(
  name: 'EntryPointRoute',
)
class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedSideMenu = sidebarMenus[0]; // StoryGeneration seçili başlasın

  late SMIBool isMenuOpenInput;


  Widget _getCurrentScreen() {
    Widget currentScreen;
    switch (selectedSideMenu.title) {
      case "Story Generation":
        currentScreen = const StoryGenerationView();
        break;
      case "Search":
        currentScreen = const SearchView();
        break;
      case "Favorites":
        currentScreen = const FavoritesView();
        break;
      case "Help":
        currentScreen = const HelpView(); 
        break;
      case "History":
        currentScreen = const StoryHistoryViewWrapper();
        break;
      case "Profile":
        currentScreen = const ProfileView();
        break;
      case "Notifications":
        currentScreen = const NotificationView();
        break;
      default:
        currentScreen = const TimerView();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey<String>(selectedSideMenu.title),
        child: currentScreen,
      ),
    );
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.surfaceContainer,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: SideBar(
              onMenuSelected: (menu) {
                setState(() {
                  selectedSideMenu = menu;
                });
              },
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: _getCurrentScreen(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                  () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                    controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}
