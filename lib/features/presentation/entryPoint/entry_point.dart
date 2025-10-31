import 'dart:math';

import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/menu.dart';
import 'package:al_anime_creator/features/presentation/help/help_view.dart';
import 'package:al_anime_creator/features/presentation/notifications/notification_view.dart';
import 'package:al_anime_creator/features/presentation/profile/profile_view.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/story_history_view.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/view/favorites_view.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/view/story_generation_view.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/cubit/sidebar_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  final String? initialMenuTitle; // Hangi ekranla açılsın
  final String? initialStoryId;   // Geçmiş ekranında otomatik açılacak hikaye

  const EntryPoint({super.key, this.initialMenuTitle, this.initialStoryId});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  late Menu selectedSideMenu; // Başlangıç menüsü parametreden gelir

  late SMIBool isMenuOpenInput;

  // Ekranlar ile başlıkları eşleştirerek kodu sadeleştir
  late Map<String, Widget> _screens;

  Widget _getCurrentScreen() {
    return AnimatedSwitcher(
      duration: ProjectDuration.medium,
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
    // Başlangıç menüsünü belirle
    final allMenus = [...sidebarMenus, ...sidebarMenus2];
    final defaultMenu = sidebarMenus[0];
    selectedSideMenu = allMenus.firstWhere(
      (m) => m.title == (widget.initialMenuTitle ?? defaultMenu.title),
      orElse: () => defaultMenu,
    );

    // Ekranları oluştur (Geçmiş için opsiyonel storyId ver)
    _screens = {
      "Hikaye Oluşturma": const StoryGenerationView(),
      "Favoriler": const FavoritesView(),
      "Yardım": const HelpView(),
      "Geçmiş": StoryHistoryViewWrapper(storyId: widget.initialStoryId),
      "Profil": const ProfileView(),
      "Bildirimler": const NotificationView(),
    };

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
    return BlocProvider(
      create: (context) => GetIt.instance<SidebarCubit>(),
      child: Scaffold(
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
    ),
    );
  }
}
