import 'package:nb_utils/nb_utils.dart';

var mAppPackageName = 'com.example.user';

//region Common Configs
const decimalPoint = 2;
const perPageItem = 20;
//endregion

//region PlayStore And AppStore URL
const appStoreBaseUrl = 'https://www.apple.com/app-store/';
//endregion

//region MESSAGES
var passwordLengthMsg = 'Password length should be more than $passwordLengthGlobal';
//endregion

const ONESIGNAL_TAG_KEY = 'appType';
const ONESIGNAL_TAG_VALUE = 'userApp';
const PER_PAGE_CHAT_LIST_COUNT = 50;

//region LIVESTREAM KEYS
const tokenStream = 'tokenStream';
const streamTab = 'streamTab';
const streamUpdateBookingList = "UpdateBookingList";
const streamUpdateDashboard = "streamUpdateDashboard";
const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";
const startTimer = "startTimer";
const pauseTimer = "pauseTimer";
const resumeTimer = "resumeTimer";
//endregion

//region default USER login
const DEFAULT_EMAIL = 'demo@user.com';
const DEFAULT_PASS = '12345678';
//endregion

//region THEME MODE TYPE
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;
//endregion

//region SHARED PREFERENCES KEYS
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
const LOGIN_TYPE = 'LOGIN_TYPE';
const PAYMENT_LIST = 'PAYMENT_LIST';
const USER_TYPE = 'USER_TYPE';

const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const USE_MATERIAL_YOU_THEME = 'USE_MATERIAL_YOU_THEME';
const IN_MAINTENANCE_MODE = 'inMaintenanceMode';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const SERVER_LANGUAGES = 'SERVER_LANGUAGES';

//endregion

//region CONFIGURATION KEYS
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
const IS_CURRENT_LOCATION = 'CURRENT_LOCATION';
//endregion

//region LOGIN TYPE
const LoginTypeUser = 'user';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'mobile';
//endregion

//region SERVICE TYPE
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_PERCENT = 'percent';
const SERVICE_TYPE_HOURLY = 'hourly';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_PAYSTACK = 'paystack';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
//endregion

const MarkAsRead = 'markas_read';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;
//endregion

//region FILE TYPE
const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region CHAT LANGUAGE
List<String> RTLLanguage = ['ar', 'ur'];
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}
//endregion

//region MessageExtension
extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'dd-MMM-yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'dd-MMM-yyyy';
const Hour12Format = 'hh:mm a';
const DATE_FORMAT_4 = 'dd MMM';
const YEAR = 'yyyy';
const bookingSaveFormat = "yyyy-MM-dd kk:mm:ss";
//endregion

const permissionStatus = 'permissionStatus';

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';

//endregion

//region User Types
const UserTypeProvider = 'provider';
const UserTypeHandyman = 'handyman';
const UserTypeUser = 'user';
//endregion
