import 'package:user/main.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceWidget extends StatelessWidget {
  final num price;
  final double? size;
  final Color? color;
  final Color? hourlyTextColor;
  final bool isBoldText;
  final bool isLineThroughEnabled;
  final bool isDiscountedPrice;
  final bool isHourlyService;

  PriceWidget({
    required this.price,
    this.size = 16.0,
    this.color,
    this.hourlyTextColor,
    this.isLineThroughEnabled = false,
    this.isBoldText = true,
    this.isDiscountedPrice = false,
    this.isHourlyService = false,
  });

  @override
  Widget build(BuildContext context) {
    TextDecoration? textDecoration() => isLineThroughEnabled ? TextDecoration.lineThrough : null;

    TextStyle _textStyle({int? aSize}) {
      return isBoldText
          ? boldTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
              decoration: textDecoration(),
            )
          : secondaryTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
              decoration: textDecoration(),
            );
    }

    return Observer(
      builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${isDiscountedPrice ? ' -' : ''}",
              style: _textStyle(),
            ),
            Row(
              children: [
                Text(appStore.currencySymbol, style: _textStyle()),
                Text(
                  "${price.validate().toStringAsFixed(decimalPoint).formatNumberWithComma()}",
                  style: _textStyle(),
                ),
                if (isHourlyService)
                  Text(
                    '/${language!.lblHr}',//lblHr
                    style: secondaryTextStyle(color: hourlyTextColor),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
