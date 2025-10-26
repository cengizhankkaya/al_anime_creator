import 'package:al_anime_creator/features/presentation/entryPoint/menu.dart';
import 'package:al_anime_creator/features/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';



class SideMenu extends StatelessWidget {
  const SideMenu(
      {super.key,
      required this.menu,
      required this.press,
      required this.riveOnInit,
      required this.selectedMenu});

  final Menu menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(height: 1, color: AppColors.of(context).transparent), // Tema üzerinden almak için değiştirildi
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: selectedMenu == menu ? 288 : 0,
              height: 56,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color:AppColors.of(context).limegreen,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ListTile(
              onTap: press,
              leading: SizedBox(
                height: 36,
                width: 36,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    selectedMenu == menu 
                      ? AppColors.of(context).blackd 
                      : AppColors.of(context).white,
                    BlendMode.srcIn,
                  ),
                  child: RiveAnimation.asset(
                    menu.rive.src,
                    artboard: menu.rive.artboard,
                    onInit: riveOnInit,
                  ),
                ),
              ),
              title: Text(
                menu.title,
                style: TextStyle(
                  color: selectedMenu == menu 
                    ? AppColors.of(context).blackd 
                    : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}