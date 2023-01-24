// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';

import 'package:user/app_theme.dart';
import 'package:user/locale/app_localizations.dart';
import 'package:user/locale/languages.dart';
import 'package:user/model/material_you_model.dart';
import 'package:user/network/services/auth_services.dart';
import 'package:user/network/services/chat_messages_service.dart';
import 'package:user/network/services/notification_service.dart';
import 'package:user/network/services/user_services.dart';
import 'package:user/screens/no_internet_screen.dart';
import 'package:user/screens/splash_screen.dart';
import 'package:user/store/app_store.dart';
import 'package:user/store/filter_store.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/configs.dart';
import 'package:user/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'model/file_model.dart';

AppStore appStore = AppStore();
FilterStore filterStore = FilterStore();
BaseLanguage? language;

UserService userService = UserService();
AuthServices authService = AuthServices();
ChatMessageService chatMessageService = ChatMessageService();
NotificationService notificationService = NotificationService();

// ignore: unnecessary_late
late List<FileModel> fileList = [];

bool mIsEnterKey = false;
String currentPackageName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  localeLanguageList = languageList();

  Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    setupFirebaseRemoteConfig();
  });

  passwordLengthGlobal = 8;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = appTextPrimaryColor;
  textPrimaryColorGlobal = appTextSecondaryColor;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = 400.milliseconds;

  await appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }

  OneSignal.shared.setAppId(ONESIGNAL_APP_ID).then((value) {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.sendTag(ONESIGNAL_TAG_KEY, ONESIGNAL_TAG_VALUE);

    saveOneSignalPlayerId();
  });

  await appStore.setUseMaterialYouTheme(
      getBoolAsync(USE_MATERIAL_YOU_THEME, defaultValue: true),
      isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setCityId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setAddress(getStringAsync(ADDRESS), isInitializing: true);
    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE),
        isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID),
        isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL),
        isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY),
        isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE),
        isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS),
        isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL),
        isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER),
        isInitializing: true);
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('Not connected');
        push(NoInternetScreen());
      } else {
        finish(context);
        log('Connected');
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: Observer(
        builder: (_) => FutureBuilder<Color>(
          future: getMaterialYouData(),
          builder: (_, snap) {
            return Observer(
              builder: (_) => MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                home: SplashScreen(),
                theme: AppTheme.lightTheme(color: snap.data),
                darkTheme: AppTheme.darkTheme(color: snap.data),
                themeMode:
                    appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                scrollBehavior: SBehavior(),
                title: APP_NAME,
                supportedLocales: LanguageDataModel.languageLocales(),
                localizationsDelegates: [
                  AppLocalizations(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) => locale,
                locale: Locale(appStore.selectedLanguageCode),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}