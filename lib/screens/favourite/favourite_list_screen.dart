import 'package:user/component/back_widget.dart';
import 'package:user/component/background_component.dart';
import 'package:user/component/loader_widget.dart';
import 'package:user/main.dart';
import 'package:user/model/wish_list_model.dart';
import 'package:user/network/rest_apis.dart';
import 'package:user/screens/favourite/widgets/favourite_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class FavouriteListScreen extends StatefulWidget {
  const FavouriteListScreen({Key? key}) : super(key: key);

  @override
  _FavouriteListScreenState createState() => _FavouriteListScreenState();
}

class _FavouriteListScreenState extends State<FavouriteListScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    LiveStream().on("RefreshList", (p0) {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language!.lblFavorite,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          FutureBuilder<WishListResponse>(
            future: getWishlist(),
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data!.data!.length == 0) return BackgroundComponent();
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(
                      snap.data!.data!.length,
                      (index) {
                        WishListData data = snap.data!.data![index];

                        return FavouriteItemWidget(
                          wishListData: data,
                          width: context.width() / 2 - 24,
                          onUpdate: () {
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                );
              }
              return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
            },
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
