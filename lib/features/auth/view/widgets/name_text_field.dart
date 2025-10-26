import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme/app_colors.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      validator: (value) =>
          value!.isEmpty ? "Ad soyad boş olamaz" : null,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SvgPicture.asset(
            "assets/icons/User.svg",
            color: AppColors.of(context).rosePink,
          ),
        ),
      ),
    );
  }
}
