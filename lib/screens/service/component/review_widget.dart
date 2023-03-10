import 'package:user/model/service_detail_model.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;

  ReviewWidget({required this.data, this.isCustomer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              circleImage(image: isCustomer ? data.customerProfileImage.validate() : data.profile_image.validate(), size: 50),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.customerName.validate(), style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                      Row(
                        children: [
                          Image.asset('images/icons/ic_star_fill.png', height: 14, fit: BoxFit.fitWidth, color: getRatingBarColor(data.rating.validate().toInt())),
                          4.width,
                          Text(data.rating.validate().toStringAsFixed(1).toString(), style: boldTextStyle(color: getRatingBarColor(data.rating.validate().toInt()), size: 14)),
                        ],
                      ),
                    ],
                  ),
                  data.created_at.validate().isNotEmpty ? Text(formatDate(data.created_at.validate(), format: DATE_FORMAT_4), style: secondaryTextStyle(size: 14)) : SizedBox(),
                  if (data.review.validate().isNotEmpty) Text(data.review.validate(), style: primaryTextStyle(size: 14)).paddingTop(8)
                ],
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }
}
