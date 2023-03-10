import 'package:user/main.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/screens/service/widgets/service_faq_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceFaqAllScreen extends StatelessWidget {
  final List<ServiceFaq> data;

  ServiceFaqAllScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.lblServiceFaq, color: context.scaffoldBackgroundColor, systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark)),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (_, index) => ServiceFaqWidget(serviceFaq: data[index]),
      ),
    );
  }
}
