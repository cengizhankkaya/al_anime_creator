  // Alt Navigasyon Çubuğu
  import 'package:flutter/material.dart';

Widget buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade400,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.black, size: 30),
            Icon(Icons.search_outlined, color: Color(0xFF0D532B), size: 30),
            Icon(Icons.person_outline, color: Color(0xFF0D532B), size: 30),
          ],
        ),
      ),
    );
  }