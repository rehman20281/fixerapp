import 'package:user/component/back_widget.dart';
import 'package:user/component/background_component.dart';
import 'package:user/main.dart';
import 'package:user/model/dashboard_model.dart';
import 'package:user/screens/dashboard/component/customer_rating_widget.dart';
import 'package:user/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerRatingScreen extends StatefulWidget {
  final List<DashboardCustomerReview> reviewData;

  CustomerRatingScreen({required this.reviewData});

  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.lblReviewsOnServices, textColor: Colors.white, color: context.primaryColor, backWidget: BackWidget()),
      body: widget.reviewData.validate().isEmpty
          ? BackgroundComponent(text: language!.lblNoRateYet, image: no_rating_bar, size: 200)
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return CustomerRatingWidget(
                  data: widget.reviewData[index],
                  onDelete: (data) {
                    widget.reviewData.remove(data);
                    setState(() {});
                  },
                );
              },
              itemCount: widget.reviewData.length,
            ),
    );
  }
}
