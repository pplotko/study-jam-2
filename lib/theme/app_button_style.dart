import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppButtonStyle{
  static final ButtonStyle linkButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(AppColors.mainLightGreen),
    textStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
    ),
  );
}