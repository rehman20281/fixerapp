import 'package:user/component/loader_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/network/rest_apis.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class AddReviewWidget extends StatefulWidget {
  final RatingData? customerReview;
  final int? bookingId;
  final int? serviceId;
  final int? handymanId;
  final bool? isCustomerRating;

  AddReviewWidget({this.customerReview, this.bookingId, this.serviceId, this.handymanId, this.isCustomerRating});

  @override
  State<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  double selectedRating = 0;

  TextEditingController reviewCont = TextEditingController();

  bool isUpdate = false;
  bool isHandymanUpdate = false;

  @override
  void initState() {
    isUpdate = widget.customerReview != null;
    isHandymanUpdate = widget.customerReview != null && widget.handymanId != null;

    if (isUpdate) {
      selectedRating = widget.customerReview!.rating.validate().toDouble();
      reviewCont.text = widget.customerReview!.review.validate();
    }

    super.initState();
  }

  void submit() async {
    hideKeyboard(context);
    Map<String, dynamic> req = {};
    if (isUpdate) {
      req = {
        "id": widget.customerReview!.id.validate(),
        "booking_id": widget.customerReview!.booking_id.validate(),
        "service_id": widget.customerReview!.service_id.validate(),
        "customer_id": appStore.userId.validate(),
        "rating": selectedRating.validate(),
        "review": reviewCont.text.validate(),
      };
      if (widget.handymanId != null) {
        req.putIfAbsent("handyman_id", () => widget.handymanId);
      }
      log(req);
      appStore.setLoading(true);

      if (widget.handymanId == null) {
        await updateReview(req).then((value) {
          toast(value.message);
          if (widget.isCustomerRating.validate(value: false)) {
            finish(context, req);
          } else {
            finish(context, true);
          }
        }).catchError((e) {
          toast(e.toString());
          finish(context, false);
        });
      } else {
        await handymanRating(req).then((value) {
          finish(context, true);
          toast(value.message);
        }).catchError((e) {
          toast(e.toString());
          finish(context, false);
        });
      }

      appStore.setLoading(false);

      return;
    }
    req = {
      "id": "",
      "booking_id": widget.bookingId.validate(),
      "service_id": widget.serviceId.validate(),
      "customer_id": appStore.userId.validate(),
      "rating": selectedRating.validate(),
      "review": reviewCont.text.validate(),
    };
    if (widget.handymanId != null) {
      req.putIfAbsent("handyman_id", () => widget.handymanId);
    }
    log(req);
    appStore.setLoading(true);

    if (widget.handymanId == null) {
      await updateReview(req).then((value) {
        finish(context, true);
        toast(value.message);
      }).catchError((e) {
        toast(e.toString());
        finish(context, false);
      });
    } else {
      await handymanRating(req).then((value) {
        finish(context, true);
        toast(value.message);
      }).catchError((e) {
        toast(e.toString());
        finish(context, false);
      });
    }

    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.width(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: boxDecorationDefault(
                  color: primaryColor,
                  borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
                ),
                child: Row(
                  children: [
                    Text(language!.review, style: boldTextStyle(color: Colors.white)).expand(),
                    IconButton(
                      icon: Icon(Icons.clear, color: Colors.white, size: 16),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Row(
                      children: [
                        Text('${language!.lblYourRating} : ', style: primaryTextStyle()),
                        16.width,
                        RatingBarWidget(
                          onRatingChanged: (rating) {
                            selectedRating = rating;
                            setState(() {});
                          },
                          activeColor: ratingBarColor,
                          inActiveColor: ratingBarColor,
                          rating: selectedRating,
                          allowHalfRating: true,
                          size: 18,
                        ).expand(),
                      ],
                    ),
                  ),
                  16.height,
                  AppTextField(
                    controller: reviewCont,
                    textFieldType: TextFieldType.OTHER,
                    minLines: 5,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: inputDecoration(
                      context,
                      hint: language!.lblEnterReview,
                    ).copyWith(fillColor: context.cardColor, filled: true),
                  ),
                  32.height,
                  Row(
                    children: [
                      AppButton(
                        text: isHandymanUpdate ? language!.lblDelete : language!.lblCancel,
                        textColor: isHandymanUpdate ? Colors.red : textPrimaryColorGlobal,
                        color: context.cardColor,
                        onTap: () {
                          if (isHandymanUpdate) {
                            showConfirmDialogCustom(
                              context,
                              primaryColor: context.primaryColor,
                              title: language!.lblDeleteRatingMsg,
                              onAccept: (c) async {
                                appStore.setLoading(true);

                                await deleteHandymanReview(id: widget.customerReview!.id.validate().toInt()).then((value) {
                                  toast(value.message);
                                  finish(context, true);
                                }).catchError((e) {
                                  toast(e.toString());
                                });

                                setState(() {});

                                appStore.setLoading(false);
                              },
                            );
                          } else {
                            finish(context);
                          }
                        },
                      ).expand(),
                      16.width,
                      AppButton(
                        textColor: Colors.white,
                        text: language!.btnSubmit,
                        color: context.primaryColor,
                        onTap: () {
                          if (selectedRating == 0) {
                            toast(language!.lblSelectRating);
                          } else {
                            submit();
                          }
                        },
                      ).expand(),
                    ],
                  )
                ],
              ).paddingAll(16)
            ],
          ),
        ),
        Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).withSize(height: 80, width: 80))
      ],
    );
  }
}