
import 'package:flutter/material.dart';

@immutable
class ProjectRadius {
  const ProjectRadius._();

  static const BorderRadius verySmall = BorderRadius.all(Radius.circular(2));
  static const BorderRadius small = BorderRadius.all(Radius.circular(4));
  static const BorderRadius normal = BorderRadius.all(Radius.circular(6));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8));
  static const BorderRadius smallMedium = BorderRadius.all(Radius.circular(10));
  static const BorderRadius large = BorderRadius.all(Radius.circular(12));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xxLarge = BorderRadius.all(Radius.circular(18));
  static const BorderRadius big = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xBig = BorderRadius.all(Radius.circular(24));
  static const BorderRadius xxBig = BorderRadius.all(Radius.circular(32));
  static const BorderRadius xxxBig = BorderRadius.all(Radius.circular(28));
  static const BorderRadius dialogLarge = BorderRadius.all(Radius.circular(40));

  static const BorderRadius topOnly = BorderRadius.only(
            topLeft: Radius.circular(10),
    topRight: Radius.circular(25),
    bottomRight: Radius.circular(25),
    bottomLeft: Radius.circular(25),
  );

  // Special border radius for top corners only
  static const BorderRadius topRightOnly = BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(32),
  );

  // Special border radius for bottom bar
  static const BorderRadius bottomBar = BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );
}