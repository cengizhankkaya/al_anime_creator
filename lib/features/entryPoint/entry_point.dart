import 'dart:math';

import 'package:al_anime_creator/features/entryPoint/menu.dart';
import 'package:al_anime_creator/features/help/help_view.dart';
import 'package:al_anime_creator/features/notifications/notification_view.dart';
import 'package:al_anime_creator/features/profile/profile_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/story_history_view.dart';
import 'package:al_anime_creator/features/storyhistory/view/favorites_view.dart';
import 'package:al_anime_creator/features/storygeneration/view/story_generation_view.dart';
import 'package:al_anime_creator/product/init/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'widgets/menu_btn.dart';
import 'widgets/side_bar.dart';

// Sihirli sayılar için sabitler
const double kSidebarWidth = 288;
const double kSidebarOpenOffset = 265;
const double kSidebarRadius = 24;
const Duration kSidebarAnimationDuration = Duration(milliseconds: 200);

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

  // Ekranlar ile başlıkları eşleştirerek kodu sadeleştir
  final Map<String, Widget> _screens = const {
    "Story Generation": StoryGenerationView(),
    "Favorites": FavoritesView(),
    "Help": HelpView(),
    "History": StoryHistoryViewWrapper(),
    "Profile": ProfileView(),
    "Notifications": NotificationView(),
  };

  Widget _getCurrentScreen() {
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
        child: _screens[selectedSideMenu.title] ?? const StoryGenerationView(),
      ),
    );
  }

  late AnimationController _sidebarAnimationController;
  late Animation<double> scaleAnimation;
  late Animation<double> yRotationAnimation;

  @override
  void initState() {
    _sidebarAnimationController = AnimationController(
        vsync: this, duration: kSidebarAnimationDuration)
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _sidebarAnimationController, curve: Curves.fastOutSlowIn));
    yRotationAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _sidebarAnimationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.of(context).sidebarColor,
      body: Stack(
        children: [
          // SideBar animasyonu
          AnimatedPositioned(
            width: kSidebarWidth,
            height: MediaQuery.of(context).size.height,
            duration: kSidebarAnimationDuration,
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -kSidebarWidth,
            top: 0,
            child: SideBar(
              onMenuSelected: (menu) {
                setState(() {
                  selectedSideMenu = menu;
                });
              },
            ),
          ),
          // Ana ekran animasyonu
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * yRotationAnimation.value - 30 * (yRotationAnimation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(yRotationAnimation.value * kSidebarOpenOffset, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(kSidebarRadius),
                  ),
                  child: _getCurrentScreen(),
                ),
              ),
            ),
          ),
          // Menü butonu animasyonu
          AnimatedPositioned(
            duration: kSidebarAnimationDuration,
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_sidebarAnimationController.value == 0) {
                  _sidebarAnimationController.forward();
                } else {
                  _sidebarAnimationController.reverse();
                }

                setState(() {
                  isSideBarOpen = !isSideBarOpen;
                });
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
