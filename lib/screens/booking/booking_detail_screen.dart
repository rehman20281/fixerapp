import 'package:user/component/app_common_dialog.dart';
import 'package:user/component/back_widget.dart';
import 'package:user/component/loader_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/booking_detail_model.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/model/user_model.dart';
import 'package:user/network/rest_apis.dart';
import 'package:user/screens/booking/booking_history_component.dart';
import 'package:user/screens/booking/component/countdown_component.dart';
import 'package:user/screens/booking/component/price_common_widget.dart';
import 'package:user/screens/booking/widgets/booking_detail_handyman_widget.dart';
import 'package:user/screens/booking/widgets/booking_detail_provider_widget.dart';
import 'package:user/screens/booking/widgets/reason_dialog.dart';
import 'package:user/screens/booking/widgets/service_proof_list_widget.dart';
import 'package:user/screens/handyman/handyman_info_screen.dart';
import 'package:user/screens/payment/payment_screen.dart';
import 'package:user/screens/provider/provider_info_screen.dart';
import 'package:user/screens/review/component/add_review_widget.dart';
import 'package:user/screens/review/rating_view_all_screen.dart';
import 'package:user/screens/service/component/review_widget.dart';
import 'package:user/screens/service/service_detail_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/constant.dart';
import 'package:user/utils/extensions/string_extensions.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/model_keys.dart';
import 'package:user/utils/widgets/cached_nework_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;

  BookingDetailScreen({required this.bookingId});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  //region Widgets
  Widget bookingIdWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          language!.lblBookingID,
          style: boldTextStyle(
              size: 16,
              color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
        ),
        Text('#' + widget.bookingId.validate().toString(),
            style: boldTextStyle(color: primaryColor, size: 18)),
      ],
    );
  }

  Widget _buildReasonWidget({required BookingDetailResponse snap}) {
    if (((snap.booking_detail!.status == BookingStatusKeys.cancelled ||
            snap.booking_detail!.status == BookingStatusKeys.rejected ||
            snap.booking_detail!.status == BookingStatusKeys.failed) &&
        ((snap.booking_detail!.reason != null &&
            snap.booking_detail!.reason!.isNotEmpty))))
      return Container(
        padding: EdgeInsets.all(16),
        color: redColor.withOpacity(0.08),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getReasonText(snap.booking_detail!.status.validate()),
                style: primaryTextStyle(color: redColor, size: 18)),
            6.height,
            Text('${snap.booking_detail!.reason.validate()}',
                style: secondaryTextStyle()),
          ],
        ),
      );

    return SizedBox();
  }

  Widget serviceDetailWidget(
      {required BookingDetail bookingDetail,
      required ServiceDetail serviceDetail}) {
    return GestureDetector(
      onTap: () {
        ServiceDetailScreen(serviceId: bookingDetail.serviceId.validate())
            .launch(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bookingDetail.serviceName.validate(),
                  style: boldTextStyle(size: 20)),
              16.height,
              Row(
                children: [
                  Text("${language!.lblDate} : ", style: secondaryTextStyle()),
                  bookingDetail.date.validate().isNotEmpty
                      ? Text(
                          formatDate(bookingDetail.date.validate(),
                              format: DATE_FORMAT_2),
                          style: boldTextStyle(size: 14),
                        )
                      : SizedBox(),
                ],
              ).visible(bookingDetail.date.validate().isNotEmpty),
              8.height,
              Row(
                children: [
                  Text("${language!.lblTime} : ", style: boldTextStyle()),
                  bookingDetail.date.validate().isNotEmpty
                      ? Text(
                          formatDate(bookingDetail.date.validate(),
                              format: Hour12Format),
                          style: secondaryTextStyle(),
                        )
                      : SizedBox(),
                ],
              ).visible(bookingDetail.date.validate().isNotEmpty),
            ],
          ).expand(),
          if (serviceDetail.attchments!.isNotEmpty)
            cachedImage(
              serviceDetail.attchments!.first,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(8)
        ],
      ),
    );
  }

  Widget handymanWidget(
      {required List<UserData> handymanList,
      required ServiceDetail serviceDetail,
      required BookingDetail bookingDetail}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.lblAboutHandyman, style: boldTextStyle(size: 16)),
          16.height,
          Column(
            children: handymanList.map((e) {
              return BookingDetailHandymanWidget(
                handymanData: e,
                serviceDetail: serviceDetail,
                bookingDetail: bookingDetail,
                onUpdate: () {
                  setState(() {});
                },
              ).onTap(() {
                HandymanInfoScreen(handymanId: e.id)
                    .launch(context)
                    .then((value) => null);
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget providerWidget(
      {required UserData providerData, required ServiceDetail serviceDetail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language!.lblAboutProvider, style: boldTextStyle(size: 18)),
        16.height,
        BookingDetailProviderWidget(providerData: providerData).onTap(() {
          ProviderInfoScreen(providerId: providerData.id).launch(context);
        }),
      ],
    );
  }

  Widget _serviceProofListWidget({required List<ServiceProof> list}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(language!.lblServiceProof, style: boldTextStyle(size: 18)),
        16.height,
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ListView.separated(
            itemBuilder: (context, index) =>
                ServiceProofListWidget(data: list[index]),
            itemCount: list.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 0);
            },
          ),
        ),
        20.height,
      ],
    );
  }

  Widget _buildDescriptionWidget({required BookingDetail bookingDetail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text(language!.hintDescription, style: boldTextStyle(size: 18)),
        16.height,
        bookingDetail.description.validate().isNotEmpty
            ? ReadMoreText(
                bookingDetail.description.validate(),
                style: secondaryTextStyle(),
                textAlign: TextAlign.justify,
              )
            : Text(language!.lblNotDescription, style: secondaryTextStyle()),
      ],
    );
  }

  Widget customerReviewWidget(
      {required List<RatingData> ratingList,
      required RatingData? customerReview,
      required BookingDetail bookingDetail}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bookingDetail.status == BookingStatusKeys.complete &&
              bookingDetail.paymentStatus == "paid")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                if (customerReview == null)
                  Text(language!.lblRatedYet, style: boldTextStyle(size: 18))
                else
                  Row(
                    children: [
                      Text(language!.yourReview, style: boldTextStyle(size: 18))
                          .expand(),
                      ic_edit_square
                          .iconImage(size: 16)
                          .paddingAll(8)
                          .onTap(() {
                        showInDialog(
                          context,
                          contentPadding: EdgeInsets.zero,
                          builder: (p0) {
                            return AddReviewWidget(
                                customerReview: customerReview);
                          },
                        ).then((value) {
                          if (value ?? false) {
                            setState(() {});
                          }
                        }).catchError((e) {
                          toast(e.toString());
                        });
                      }),
                      ic_delete.iconImage(size: 16).paddingAll(8).onTap(() {
                        deleteDialog(context, onSuccess: () async {
                          appStore.setLoading(true);

                          await deleteReview(id: customerReview.id.validate())
                              .then((value) {
                            toast(value.message);
                          }).catchError((e) {
                            toast(e.toString());
                          });

                          setState(() {});

                          appStore.setLoading(false);
                        },
                            title: language!.lblDeleteReview,
                            subTitle: language!.lblConfirmReviewSubTitle);
                        return;
                      }),
                    ],
                  ),
                16.height,
                if (customerReview == null)
                  AppButton(
                    color: context.primaryColor,
                    onTap: () {
                      showInDialog(
                        context,
                        contentPadding: EdgeInsets.zero,
                        builder: (p0) {
                          return AddReviewWidget(
                              serviceId: bookingDetail.serviceId.validate(),
                              bookingId: bookingDetail.id.validate());
                        },
                      ).then((value) {
                        if (value) {
                          setState(() {});
                        }
                      }).catchError((e) {
                        log(e.toString());
                      });
                    },
                    text: language!.btnRate,
                    textColor: Colors.white,
                  ).withWidth(context.width())
                else
                  ReviewWidget(data: customerReview)
              ],
            ),
          16.height,
          if (ratingList.isNotEmpty)
            Row(
              children: [
                Text(language!.review, style: boldTextStyle(size: 18)).expand(),
                Text(language!.lblViewAll, style: secondaryTextStyle())
                    .onTap(() {
                  RatingViewAllScreen(ratingData: ratingList).launch(context);
                })
              ],
            ),
          16.height,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ratingList.length,
            itemBuilder: (context, index) =>
                ReviewWidget(data: ratingList[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterWidget({required BookingDetailResponse value}) {
    if (value.booking_detail!.isHourlyService &&
        (value.booking_detail!.status == BookingStatusKeys.inProgress ||
            value.booking_detail!.status == BookingStatusKeys.hold ||
            value.booking_detail!.status == BookingStatusKeys.complete ||
            value.booking_detail!.status == BookingStatusKeys.onGoing))
      return Column(
        children: [
          16.height,
          CountdownWidget(bookingDetailResponse: value),
        ],
      );
    else
      return Offstage();
  }

  Widget _action({required BookingDetailResponse status}) {
    if (status.booking_detail!.status == BookingStatusKeys.pending ||
        status.booking_detail!.status == BookingStatusKeys.accept) {
      return AppButton(
        text: language!.lblCancelBooking,
        textColor: Colors.white,
        color: primaryColor,
        onTap: () {
          _handleCancelClick(status: status);
        },
      );
    } else if (status.booking_detail!.status == BookingStatusKeys.onGoing) {
      return AppButton(
        text: language!.lblStart,
        textColor: Colors.white,
        color: Colors.green,
        onTap: () {
          _handleStartClick(status: status);
        },
      );
    } else if (status.booking_detail!.status == BookingStatusKeys.inProgress) {
      return Row(
        children: [
          AppButton(
            text: language!.lblHold,
            textColor: Colors.white,
            color: holdColor,
            onTap: () {
              _handleHoldClick(status: status);
            },
          ).expand(),
          16.width,
          AppButton(
            text: language!.done,
            textColor: Colors.white,
            color: primaryColor,
            onTap: () {
              _handleDoneClick(status: status);
            },
          ).expand(),
        ],
      );
    } else if (status.booking_detail!.status == BookingStatusKeys.hold) {
      return Row(
        children: [
          AppButton(
            text: language!.lblResume,
            textColor: Colors.white,
            color: primaryColor,
            onTap: () {
              _handleResumeClick(status: status);
            },
          ).expand(),
          16.width,
          AppButton(
            text: language!.lblCancel,
            textColor: Colors.white,
            color: cancelledColor,
            onTap: () {
              _handleCancelClick(status: status);
            },
          ).expand(),
        ],
      );
    } else if (status.booking_detail!.status == BookingStatusKeys.complete &&
        (status.booking_detail!.paymentStatus == null)) {
      return AppButton(
        text: language!.lblPayNow,
        textColor: Colors.white,
        color: Colors.green,
        onTap: () {
          PaymentScreen(data: status).launch(context);
        },
      );
    }

    return SizedBox();
  }

  //endregion

  //region ActionMethods
  //region Cancel
  void _handleCancelClick({required BookingDetailResponse status}) {
    if (status.booking_detail!.status == BookingStatusKeys.pending ||
        status.booking_detail!.status == BookingStatusKeys.accept ||
        status.booking_detail!.status == BookingStatusKeys.hold) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (context) {
          return AppCommonDialog(
            title: language!.lblCancelReason,
            child: ReasonDialog(status: status),
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {});
        }
      });
    }
  }

  //endregion

  //region Hold Click
  void _handleHoldClick({required BookingDetailResponse status}) {
    if (status.booking_detail!.status == BookingStatusKeys.inProgress) {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.scaffoldBackgroundColor,
        builder: (context) {
          return AppCommonDialog(
            title: language!.lblConfirmService,
            child: ReasonDialog(
                status: status, currentStatus: BookingStatusKeys.hold),
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {});
        }
      });
    }
  }

  //endregion

  //region Resume Service
  void _handleResumeClick({required BookingDetailResponse status}) {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.CONFIRMATION,
      primaryColor: context.primaryColor,
      negativeText: language!.lblNo,
      title: language!.lblConFirmResumeService,
      onAccept: (c) {
        resumeClick(status: status);
      },
    );
  }

  void resumeClick({required BookingDetailResponse status}) async {
    Map request = {
      CommonKeys.id: status.booking_detail!.id.validate(),
      BookingUpdateKeys.startAt:
          formatDate(DateTime.now().toString(), format: bookingSaveFormat),
      BookingUpdateKeys.endAt: status.booking_detail!.endAt.validate(),
      BookingUpdateKeys.durationDiff:
          status.booking_detail!.durationDiff.validate(),
      BookingUpdateKeys.reason: "",
      CommonKeys.status: BookingStatusKeys.inProgress,
    };

    log("req $request");
    appStore.setLoading(true);

    await updateBooking(request).then((res) async {
      toast(res.message!);

      commonStartTimer(
          isHourlyService: status.booking_detail!.isHourlyService,
          status: BookingStatusKeys.inProgress,
          timeInSec: status.booking_detail!.durationDiff.validate().toInt());
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  //endregion

  //region Start Service
  void startClick({required BookingDetailResponse status}) async {
    Map request = {
      CommonKeys.id: status.booking_detail!.id.validate(),
      BookingUpdateKeys.startAt:
          formatDate(DateTime.now().toString(), format: bookingSaveFormat),
      BookingUpdateKeys.endAt: status.booking_detail!.endAt.validate(),
      BookingUpdateKeys.durationDiff: 0,
      BookingUpdateKeys.reason: "",
      CommonKeys.status: BookingStatusKeys.inProgress,
    };

    log("req $request");
    appStore.setLoading(true);

    await updateBooking(request).then((res) async {
      toast(res.message!);
      commonStartTimer(
          isHourlyService: status.booking_detail!.isHourlyService,
          status: BookingStatusKeys.inProgress,
          timeInSec: status.booking_detail!.durationDiff.validate().toInt());

      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  void _handleStartClick({required BookingDetailResponse status}) {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.CONFIRMATION,
      primaryColor: context.primaryColor,
      negativeText: language!.lblNo,
      onAccept: (c) {
        startClick(status: status);
      },
    );
  }

  //endregion

  //region Done Service
  void doneClick({required BookingDetailResponse status}) async {
    String endDateTime = DateFormat(bookingSaveFormat).format(DateTime.now());

    num durationDiff = DateTime.parse(endDateTime.validate())
        .difference(DateTime.parse(status.booking_detail!.startAt.validate()))
        .inSeconds;

    Map request = {
      CommonKeys.id: status.booking_detail!.id.validate(),
      BookingUpdateKeys.startAt: status.booking_detail!.startAt.validate(),
      BookingUpdateKeys.endAt: endDateTime,
      BookingUpdateKeys.durationDiff: durationDiff,
      BookingUpdateKeys.reason: "Done",
      CommonKeys.status: BookingStatusKeys.complete,
    };

    log("req $request");
    appStore.setLoading(true);

    await updateBooking(request).then((res) async {
      toast(res.message!);
      commonStartTimer(
          isHourlyService: status.booking_detail!.isHourlyService,
          status: BookingStatusKeys.complete,
          timeInSec: status.booking_detail!.durationDiff.validate().toInt());
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  void _handleDoneClick({required BookingDetailResponse status}) {
    showConfirmDialogCustom(
      context,
      negativeText: language!.lblNo,
      dialogType: DialogType.CONFIRMATION,
      primaryColor: context.primaryColor,
      title: language!.lblEndServicesMsg,
      onAccept: (c) {
        doneClick(status: status);
      },
    );
  }

  //endregion
  //endregion

  //region Methods

  void commonStartTimer(
      {required bool isHourlyService,
      required String status,
      required int timeInSec}) {
    if (isHourlyService) {
      Map<String, dynamic> liveStreamRequest = {
        "inSeconds": timeInSec,
        "status": status,
      };
      LiveStream().emit(startTimer, liveStreamRequest);
    }
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().emit(pauseTimer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<BookingDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return Stack(
          children: [
            Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildReasonWidget(snap: snap.data!),
                      Padding(
                        padding: EdgeInsets.fromLTRB(18, 8, 18, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            8.height,
                            bookingIdWidget(),
                            16.height,
                            Divider(height: 0),
                            16.height,
                            serviceDetailWidget(
                                bookingDetail: snap.data!.booking_detail!,
                                serviceDetail: snap.data!.service!),
                            16.height,
                            Divider(height: 0),
                            _buildCounterWidget(value: snap.data!),
                            //if (snap.data!.booking_detail != null)
                            //_buildDescriptionWidget(bookingDetail: snap.data!.booking_detail!),
                            if (snap.data!.serviceProof.validate().isNotEmpty)
                              _serviceProofListWidget(
                                  list: snap.data!.serviceProof.validate()),
                            if (snap.data!.handyman_data!.isNotEmpty)
                              Column(
                                children: [
                                  24.height,
                                  handymanWidget(
                                      handymanList: snap.data!.handyman_data!,
                                      serviceDetail: snap.data!.service!,
                                      bookingDetail:
                                          snap.data!.booking_detail!),
                                ],
                              ),
                            24.height,
                            if (snap.data!.provider_data != null)
                              providerWidget(
                                  providerData: snap.data!.provider_data!,
                                  serviceDetail: snap.data!.service!),
                            28.height,
                            PriceCommonWidget(
                                bookingDetail: snap.data!.booking_detail!,
                                serviceDetail: snap.data!.service!,
                                taxes:
                                    snap.data!.booking_detail!.taxes.validate(),
                                couponData: snap.data!.couponData),
                            16.height,
                            customerReviewWidget(
                                ratingList: snap.data!.rating_data.validate(),
                                customerReview: snap.data!.customer_review,
                                bookingDetail: snap.data!.booking_detail!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _action(status: snap.data!),
                )
              ],
            ),
            Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading),
            )
          ],
        );
      }
      return LoaderWidget().center();
    }

    return FutureBuilder<BookingDetailResponse>(
      future: getBookingDetail({
        CommonKeys.bookingId: widget.bookingId.toString(),
        CommonKeys.customerId: appStore.userId,
      }),
      builder: (context, snap) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            return await 2.seconds.delay;
          },
          child: Scaffold(
            appBar: appBarWidget(
              snap.hasData
                  ? snap.data!.booking_detail!.statusLabel.validate()
                  : "",
              color: context.primaryColor,
              textColor: Colors.white,
              showBack: true,
              backWidget: BackWidget(),
              actions: [
                if (snap.hasData)
                  TextButton(
                    child: Text(language!.lblCheckStatus,
                        style: primaryTextStyle(color: Colors.white)),
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: radiusOnly(
                                topLeft: defaultRadius,
                                topRight: defaultRadius)),
                        builder: (_) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.50,
                            minChildSize: 0.2,
                            maxChildSize: 1,
                            builder: (context, scrollController) =>
                                BookingHistoryComponent(
                                    data: snap.data!.booking_activity!.reversed
                                        .toList(),
                                    scrollController: scrollController),
                          );
                        },
                      );
                    },
                  ).paddingRight(16)
              ],
            ),
            body: buildBodyWidget(snap),
          ),
        );
      },
    );
  }
}
