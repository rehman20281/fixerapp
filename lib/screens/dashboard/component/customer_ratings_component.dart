import 'package:user/main.dart';
import 'package:user/model/dashboard_model.dart';
import 'package:user/screens/auth/sign_in_screen.dart';
import 'package:user/screens/dashboard/customer_rating_screen.dart';
import 'package:user/screens/dashboard/home_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerRatingsComponent extends StatelessWidget {
  final List<DashboardCustomerReview> reviewData;

  CustomerRatingsComponent({required this.reviewData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      width: context.width(),
      decoration: boxDecorationDefault(color: primaryColor, borderRadius: radius(0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ic_customer_rating_stars),
          26.height,
          Text(language!.lblIntroducingCustomerRating, style: primaryTextStyle(size: 20, color: Colors.white)),
          16.height,
          AppButton(
            text: language!.lblSeeYourRatings,
            textStyle: primaryTextStyle(color: appStore.isDarkMode ? textPrimaryColorGlobal : primaryColor),
            onTap: () {
              if (appStore.isLoggedIn) {
                CustomerRatingScreen(reviewData: reviewData).launch(context);
              } else {
                setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
                SignInScreen().launch(context).then(
                  (value) {
                    if (value ?? false) {
                      HomeScreen().launch(context, isNewTask: true);
                    }
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
