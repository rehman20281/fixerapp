import 'package:user/main.dart';
import 'package:user/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = defaultPrimaryColor;
  }

  return primaryColor;
}
