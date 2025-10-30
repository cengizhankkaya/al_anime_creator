import 'package:al_anime_creator/features/core/constans/index.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/menu.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/cubit/sidebar_cubit.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/cubit/sidebar_state.dart';
import 'package:al_anime_creator/features/core/index.dart';
import 'package:al_anime_creator/features/core/constans/rive_utils.dart' show RiveUtils;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  final Function(Menu)? onMenuSelected;

  const SideBar({super.key, this.onMenuSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus[0];
   // StoryGeneration seçili başlasın
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SidebarCubit, SidebarState>(
      builder: (context, state) {
        // Kullanıcı çıkış yaptıysa veya hata varsa boş widget
        if (state is SidebarUnauthenticated || state is SidebarError) {
          return const SizedBox.shrink();
        }
        
        return SafeArea(
          child: Container(
            width: 288,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.of(context).sidebarColor.withValues(alpha: 0.9),
              borderRadius: ProjectRadius.xxBig,
            ),
            child: DefaultTextStyle(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(state),
              Padding(
                padding: ProjectPadding.onlyLeft24Top32Bottom16,
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              ...sidebarMenus.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      widget.onMenuSelected?.call(menu);
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                  )),
              Padding(
                padding: ProjectPadding.onlyLeft24Top32Bottom16,
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              ...sidebarMenus2.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      widget.onMenuSelected?.call(menu);
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(SidebarState state) {
    if (state is SidebarLoading) {
      return const InfoCard(
        name: 'Yükleniyor...',
        bio: '',
      );
    }

    if (state is SidebarLoaded) {
      return InfoCard(
        name: state.userProfile.name,
        bio: state.userProfile.email,
        avatarUrl: state.userProfile.avatarUrl,
      );
    }

    // Default durum
    return const InfoCard(
      name: 'Kullanıcı',
      bio: '',
    );
  }
}
