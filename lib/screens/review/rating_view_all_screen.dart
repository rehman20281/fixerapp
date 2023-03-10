import 'package:user/component/back_widget.dart';
import 'package:user/component/background_component.dart';
import 'package:user/main.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/screens/service/component/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RatingViewAllScreen extends StatefulWidget {
  final List<RatingData> ratingData;

  RatingViewAllScreen({required this.ratingData});

  @override
  _RatingViewAllScreenState createState() => _RatingViewAllScreenState();
}

class _RatingViewAllScreenState extends State<RatingViewAllScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.lblServiceRatings, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: widget.ratingData.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: widget.ratingData.length,
              itemBuilder: (context, index) => ReviewWidget(data: widget.ratingData[index]),
            )
          : BackgroundComponent(size: 200, text: language!.lblNoServiceRatings),
    );
  }
}
