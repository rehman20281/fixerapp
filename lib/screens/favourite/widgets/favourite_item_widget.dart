import 'package:user/component/disabled_rating_bar_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/wish_list_model.dart';
import 'package:user/screens/service/service_detail_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/extensions/string_extensions.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/widgets/cached_nework_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FavouriteItemWidget extends StatefulWidget {
  final WishListData? wishListData;
  final double? width;
  final VoidCallback? onUpdate;

  FavouriteItemWidget({this.wishListData, this.width, this.onUpdate});

  @override
  FavouriteItemWidgetState createState() => FavouriteItemWidgetState();
}

class FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  bool mIsInWishList = false;

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
    return GestureDetector(
      onTap: () async {
        await ServiceDetailScreen(serviceId: widget.wishListData!.service_id.validate().toInt()).launch(context);
        setState(() {});
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.cardColor),
        margin: EdgeInsets.only(bottom: 16),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomLeft,
              children: [
                cachedImage(
                  widget.wishListData!.service_attchments.validate().isNotEmpty ? widget.wishListData!.service_attchments!.first.validate() : '',
                  fit: BoxFit.cover,
                  height: 120,
                  width: context.width(),
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    constraints: BoxConstraints(maxWidth: context.width() * 0.22),
                    decoration: boxDecorationWithShadow(backgroundColor: context.cardColor.withOpacity(0.9), borderRadius: radius(24)),
                    child: Marquee(
                      directionMarguee: DirectionMarguee.oneDirection,
                      child: Text(
                        "${widget.wishListData!.category_name.validate()}".toUpperCase(),
                        style: boldTextStyle(color: appStore.isDarkMode ? white : primaryColor, size: 12),
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -16,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: primaryColor,
                      borderRadius: radius(24),
                      border: Border.all(color: white, width: 2),
                    ),
                    child: RichTextWidget(
                      overflow: TextOverflow.ellipsis,
                      list: [
                        if (widget.wishListData!.price_format != null)
                          TextSpan(
                            text: widget.wishListData!.price_format..validate().toString(),
                            style: boldTextStyle(color: white, size: 14),
                          ),
                        TextSpan(
                          text: widget.wishListData!.isHourlyService ? ' /hr' : '',
                          style: secondaryTextStyle(size: 14, color: white),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 8, vertical: 4),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 8),
                    decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                    child: widget.wishListData!.is_favourite == 0 ? ic_fill_heart.iconImage(color: favouriteColor, size: 18) : ic_heart.iconImage(color: unFavouriteColor, size: 18),
                  ).onTap(
                    () async {
                      if (widget.wishListData!.is_favourite == 0) {
                        widget.wishListData!.is_favourite = 1;
                        setState(() {});

                        await removeToWishList(serviceId: widget.wishListData!.service_id.validate().toInt()).then((value) {
                          if (!value) {
                            widget.wishListData!.is_favourite = 0;
                            setState(() {});
                          }
                        });
                      } else {
                        widget.wishListData!.is_favourite = 0;
                        setState(() {});

                        await addToWishList(serviceId: widget.wishListData!.service_id.validate().toInt()).then((value) {
                          if (!value) {
                            widget.wishListData!.is_favourite = 1;
                            setState(() {});
                          }
                        });
                      }
                      widget.onUpdate?.call();
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                DisabledRatingBarWidget(rating: widget.wishListData!.total_rating.validate()),
                16.height,
                Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(widget.wishListData!.name.validate(), style: boldTextStyle(size: 16)),
                ),
                12.height,
                Row(
                  children: [
                    cachedImage(
                      widget.wishListData!.provider_image,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(16),
                    8.width,
                    if (widget.wishListData!.provider_name.validate().isNotEmpty)
                      Text(
                        widget.wishListData!.provider_name.validate(),
                        style: secondaryTextStyle(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ).expand()
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
          ],
        ),
      ),
    );
  }
}
