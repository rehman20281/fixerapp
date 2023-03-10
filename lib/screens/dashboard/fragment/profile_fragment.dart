import 'package:user/component/loader_widget.dart';
import 'package:user/component/theme_selection_dailog.dart';
import 'package:user/main.dart';
import 'package:user/network/rest_apis.dart';
import 'package:user/screens/auth/change_password_screen.dart';
import 'package:user/screens/auth/edit_profile_screen.dart';
import 'package:user/screens/auth/sign_in_screen.dart';
import 'package:user/screens/favourite/favourite_list_screen.dart';
import 'package:user/screens/language_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/configs.dart';
import 'package:user/utils/constant.dart';
import 'package:user/utils/extensions/string_extensions.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/widgets/cached_nework_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String number = "123467890";

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget get trailing {
    return ic_arrow_right.iconImage(size: 16);
  }

  double iconSize = 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.profile, textColor: white, elevation: 0.0, color: context.primaryColor, showBack: false),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        32.height,
                        if (appStore.userProfileImage.isNotEmpty)
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              cachedImage(
                                appStore.userProfileImage,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(60),
                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(6),
                                  decoration: boxDecorationDefault(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    border: Border.all(color: context.cardColor, width: 2),
                                  ),
                                  child: Icon(AntDesign.edit, color: white, size: 18),
                                ).onTap(() {
                                  EditProfileScreen().launch(context);
                                }),
                              ),
                            ],
                          ),
                        16.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(appStore.userFullName, style: boldTextStyle(color: primaryColor, size: 22)),
                            8.height,
                            Text(appStore.userEmail, style: secondaryTextStyle(size: 18)),
                            8.height,
                          ],
                        ),
                        32.height,
                      ],
                    ).center().visible(appStore.isLoggedIn),
                    SettingSection(
                      title: Text(language!.lblGENERAL, style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                      divider: Offstage(),
                      items: [
                        SettingItemWidget(
                          leading: ic_darkmode.iconImage(size: iconSize),
                          title: language!.appTheme,
                          trailing: trailing,
                          onTap: () async {
                            await showInDialog(
                              context,
                              builder: (context) => ThemeSelectionDaiLog(),
                              contentPadding: EdgeInsets.zero,
                            );
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_lock.iconImage(size: iconSize),
                          title: language!.changePassword,
                          trailing: trailing,
                          onTap: () {
                            ChangePasswordScreen().launch(context);
                          },
                        ).visible(appStore.isLoggedIn && appStore.loginType == ''),
                        SettingItemWidget(
                          leading: ic_language.iconImage(size: iconSize),
                          title: language!.language,
                          trailing: trailing,
                          onTap: () {
                            LanguagesScreen().launch(context);
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_heart.iconImage(size: iconSize),
                          title: language!.lblFavorite,
                          trailing: trailing,
                          onTap: () {
                            FavouriteListScreen().launch(context);
                          },
                        ).visible(appStore.isLoggedIn),
                      ],
                    ),
                    SettingSection(
                      title: Text(language!.lblAboutApp.toUpperCase(), style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                      divider: Offstage(),
                      items: [
                        8.height,
                        SettingItemWidget(
                          leading: ic_shield_done.iconImage(size: iconSize),
                          title: language!.privacyPolicy,
                          onTap: () {
                            checkIfLink(context, appStore.privacyPolicy.validate(), title: language!.privacyPolicy);
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_document.iconImage(size: iconSize),
                          title: language!.termsCondition,
                          onTap: () {
                            checkIfLink(context, appStore.termConditions.validate(), title: language!.termsCondition);
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_helpAndSupport.iconImage(size: iconSize),
                          title: language!.helpSupport,
                          onTap: () {
                            checkIfLink(context, appStore.inquiryEmail.validate(), title: language!.helpSupport);
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_calling.iconImage(size: iconSize),
                          title: language!.lblHelplineNumber,
                          onTap: () {
                            launchCall(appStore.helplineNumber.validate());
                          },
                        ),
                        64.height.visible(appStore.isLoggedIn),
                        TextButton(
                          child: Text(language!.logout, style: boldTextStyle(color: primaryColor, size: 18)),
                          onPressed: () {
                            logout(context);
                          },
                        ).center().visible(appStore.isLoggedIn),
                        SettingItemWidget(
                          leading: Icon(MaterialCommunityIcons.logout, color: context.iconColor),
                          title: language!.signIn,
                          onTap: () {
                            SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
                          },
                        ).visible(!appStore.isLoggedIn),
                        FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return Text("v${snap.data!.version.validate(value: '1.0.0')}", style: secondaryTextStyle(size: 14));
                            }
                            return snapWidgetHelper(snap, loadingWidget: Offstage());
                          },
                        ).center(),
                      ],
                    ),
                  ],
                ),
              ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
            ],
          );
        },
      ),
    );
  }
}
