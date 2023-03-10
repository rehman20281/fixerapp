import 'package:user/component/disabled_rating_bar_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/booking_detail_model.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/model/user_model.dart';
import 'package:user/screens/chat/user_chat_screen.dart';
import 'package:user/screens/review/component/add_review_widget.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/extensions/string_extensions.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailHandymanWidget extends StatefulWidget {
  final UserData handymanData;
  final ServiceDetail serviceDetail;
  final BookingDetail bookingDetail;
  final Function() onUpdate;

  BookingDetailHandymanWidget({required this.handymanData, required this.serviceDetail, required this.bookingDetail, required this.onUpdate});

  @override
  BookingDetailHandymanWidgetState createState() => BookingDetailHandymanWidgetState();
}

class BookingDetailHandymanWidgetState extends State<BookingDetailHandymanWidget> {
  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              circleImage(image: widget.handymanData.profile_image.validate(), size: 70),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.handymanData.display_name.validate(), style: boldTextStyle()),
                  2.height,
                  if (widget.serviceDetail.categoryName.validate().isNotEmpty)
                    Text(
                      widget.serviceDetail.categoryName.validate(),
                      style: secondaryTextStyle(),
                    ),
                  if (widget.serviceDetail.categoryName.validate().isNotEmpty) 10.height,
                  DisabledRatingBarWidget(rating: widget.handymanData.handymanRating.validate().toDouble()),
                ],
              ).expand()
            ],
          ),
          8.height,
          Divider(),
          8.height,
          Row(
            children: [
              if (widget.handymanData.contact_number.validate().isNotEmpty)
                AppButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ic_calling.iconImage(size: 18, color: Colors.white),
                      8.width,
                      Text(language!.lblCall, style: boldTextStyle(color: white)),
                    ],
                  ),
                  width: context.width(),
                  color: primaryColor,
                  elevation: 0,
                  onTap: () {
                    launchCall(widget.handymanData.contact_number.validate());
                  },
                ).expand(),
              24.width,
              AppButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ic_chat.iconImage(size: 18),
                    8.width,
                    Text(language!.lblchat, style: boldTextStyle()),
                  ],
                ),
                width: context.width(),
                elevation: 0,
                color: context.scaffoldBackgroundColor,
                onTap: () async {
                  await userService.getUser(email: widget.handymanData.email.validate()).then((value) {
                    widget.handymanData.uid = value.uid;
                  }).catchError((e) {
                    log(e.toString());
                  });
                  UserChatScreen(receiverUser: widget.handymanData).launch(context);
                },
              ).expand(),
            ],
          ),
          8.height,
          if (widget.bookingDetail.status == BookingStatusKeys.complete && widget.bookingDetail.paymentStatus == "paid")
            TextButton(
              onPressed: () {
                _handleHandymanRatingClick();
              },
              child: Text(widget.handymanData.handymanReview != null ? language!.lblEditYourReview : language!.lblRateHandyman, style: boldTextStyle(color: primaryColor)),
            ).center()
        ],
      ),
    );
  }

  void _handleHandymanRatingClick() {
    if (widget.handymanData.handymanReview == null) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.scaffoldBackgroundColor,
        dialogAnimation: DialogAnimation.SCALE,
        builder: (p0) {
          return AddReviewWidget(
            serviceId: widget.serviceDetail.id.validate(),
            bookingId: widget.bookingDetail.id.validate(),
            handymanId: widget.handymanData.id,
          );
        },
      ).then((value) {
        if (value ?? false) {
          widget.onUpdate.call();
        }
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.scaffoldBackgroundColor,
        dialogAnimation: DialogAnimation.SCALE,
        builder: (p0) {
          return AddReviewWidget(
            serviceId: widget.serviceDetail.id.validate(),
            bookingId: widget.bookingDetail.id.validate(),
            handymanId: widget.handymanData.id,
            customerReview: RatingData(
              booking_id: widget.handymanData.handymanReview!.bookingId,
              created_at: widget.handymanData.handymanReview!.createdAt,
              customer_name: widget.handymanData.handymanReview!.customerName,
              id: widget.handymanData.handymanReview!.id,
              rating: widget.handymanData.handymanReview!.rating,
              customer_id: widget.handymanData.handymanReview!.customerId,
              review: widget.handymanData.handymanReview!.review,
              service_id: widget.handymanData.handymanReview!.serviceId,
            ),
          );
        },
      ).then((value) {
        if (value ?? false) {
          widget.onUpdate.call();
        }
      }).catchError((e) {
        log(e.toString());
      });
    }
  }
}
