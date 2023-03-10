import 'package:user/component/disabled_rating_bar_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/user_model.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailProviderWidget extends StatefulWidget {
  final UserData providerData;

  BookingDetailProviderWidget({required this.providerData});

  @override
  BookingDetailProviderWidgetState createState() => BookingDetailProviderWidgetState();
}

class BookingDetailProviderWidgetState extends State<BookingDetailProviderWidget> {
  UserData userData = UserData();

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userData = widget.providerData;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              circleImage(image: widget.providerData.profile_image.validate(), size: 70),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.providerData.display_name}', style: boldTextStyle()),
                  4.height,
                  DisabledRatingBarWidget(rating: widget.providerData.providersServiceRating.validate()),
                ],
              ).expand(),
              Image.asset(ic_verified, height: 24, width: 24, color: verifyAcColor),
            ],
          ),
          16.height,
          TextIcon(
            spacing: 10,
            onTap: () {
              launchMail("${widget.providerData.email.validate()}");
            },
            prefix: Image.asset(ic_message, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
            text: '${widget.providerData.email.validate()}',
          ),
          if (widget.providerData.address.validate().isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                TextIcon(
                  spacing: 10,
                  onTap: () {
                    launchMap("${widget.providerData.address.validate()}");
                  },
                  expandedText: true,
                  prefix: Image.asset(ic_location, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
                  text: '${widget.providerData.address.validate()}',
                ),
              ],
            ),
          8.height,
          TextIcon(
            spacing: 10,
            onTap: () {
              launchCall(widget.providerData.contact_number.validate());
            },
            prefix: Image.asset(ic_calling, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
            text: '${widget.providerData.contact_number.validate()}',
          ),
        ],
      ),
    );
  }
}
