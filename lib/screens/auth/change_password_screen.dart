import 'package:user/component/base_scaffold_widget.dart';
import 'package:user/main.dart';
import 'package:user/network/rest_apis.dart';
import 'package:user/screens/dashboard/home_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/constant.dart';
import 'package:user/utils/extensions/string_extensions.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode reenterPasswordFocus = FocusNode();

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

  Future<void> changePassword() async {
    await setValue(USER_PASSWORD, newPasswordCont.text);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.oldPassword: oldPasswordCont.text,
        UserKeys.newPassword: newPasswordCont.text,
      };
      appStore.setLoading(true);

      await changeUserPassword(request).then((res) async {
        await authService.changePassword(newPasswordCont.text).catchError((e) {
          log(e.toString());
        });

        toast(res.message.validate());
        HomeScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language!.changePassword,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.lblChangePwdTitle, style: primaryTextStyle()),
              24.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: oldPasswordCont,
                focus: oldPasswordFocus,
                nextFocus: newPasswordFocus,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                decoration: inputDecoration(context, hint: language!.hintOldPasswordTxt),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: newPasswordCont,
                focus: newPasswordFocus,
                nextFocus: reenterPasswordFocus,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                decoration: inputDecoration(context, hint: language!.hintNewPasswordTxt),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: reenterPasswordCont,
                focus: reenterPasswordFocus,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                validator: (v) {
                  if (newPasswordCont.text != v) {
                    return language!.passwordNotMatch;
                  } else if (reenterPasswordCont.text.isEmpty) {
                    return errorThisFieldRequired;
                  }
                  return null;
                },
                onFieldSubmitted: (s) {
                  if (appStore.userEmail != DEFAULT_EMAIL) {
                    changePassword();
                  } else {
                    toast(language!.lblUnAuthorized);
                  }
                },
                decoration: inputDecoration(context, hint: language!.hintReenterPasswordTxt),
              ),
              24.height,
              AppButton(
                text: language!.confirm,
                height: 40,
                color: primaryColor,
                textStyle: primaryTextStyle(color: white),
                width: context.width() - context.navigationBarHeight,
                onTap: () {
                  if (appStore.userEmail != DEFAULT_EMAIL) {
                    changePassword();
                  } else {
                    toast(language!.lblUnAuthorized);
                  }
                },
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}
