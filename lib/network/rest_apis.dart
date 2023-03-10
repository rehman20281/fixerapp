import 'dart:convert';

import 'package:user/main.dart';
import 'package:user/model/booking_detail_model.dart';
import 'package:user/model/booking_list_model.dart';
import 'package:user/model/booking_status_model.dart';
import 'package:user/model/category_model.dart';
import 'package:user/model/change_password_model.dart';
import 'package:user/model/city_list_model.dart';
import 'package:user/model/country_list_model.dart';
import 'package:user/model/dashboard_model.dart';
import 'package:user/model/login_model.dart';
import 'package:user/model/notification_model.dart';
import 'package:user/model/provider_info_model.dart';
import 'package:user/model/provider_list_model.dart';
import 'package:user/model/register_model.dart';
import 'package:user/model/search_response.dart';
import 'package:user/model/service_detail_model.dart';
import 'package:user/model/service_response.dart';
import 'package:user/model/state_list_model.dart';
import 'package:user/model/user_model.dart';
import 'package:user/model/wish_list_model.dart';
import 'package:user/network/network_utils.dart';
import 'package:user/screens/dashboard/home_screen.dart';
import 'package:user/utils/colors.dart';
import 'package:user/utils/common.dart';
import 'package:user/utils/configs.dart';
import 'package:user/utils/constant.dart';
import 'package:user/utils/images.dart';
import 'package:user/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

//region Auth Api
Future<RegisterResponse> createUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  if (!isSocialLogin) await appStore.setLoginType(LoginTypeUser);

  LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? 'social-login' : 'login', request: request, method: HttpMethod.POST)));

  return res;
}

Future<void> saveUserData(UserData data) async {
  if (data.api_token.validate().isNotEmpty) await appStore.setToken(data.api_token.validate());
  await appStore.setUserId(data.id.validate());
  await appStore.setFirstName(data.first_name.validate());
  await appStore.setLastName(data.last_name.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.country_id.validate());
  await appStore.setStateId(data.state_id.validate());
  await appStore.setCityId(data.city_id.validate());
  await appStore.setContactNumber('${data.contact_number.validate()}');
  await appStore.setLoginType('${data.loginType.validate()}');
  if (data.loginType != "google") await appStore.setUserProfile(data.profile_image.validate());
  await userService.getUser(email: data.email.validate()).then((value) async {
    await appStore.setUId(value.uid.validate());
  }).catchError((e) {
    log(e.toString());
  });
  await appStore.setAddress(data.address != null ? data.address.validate() : '');

  await appStore.setLoggedIn(true);
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(logout_logo, width: context.width(), fit: BoxFit.cover),
          32.height,
          Text(language!.lblLogoutTitle, style: boldTextStyle(size: 20)),
          16.height,
          Text(language!.lblLogoutSubTitle, style: secondaryTextStyle()),
          28.height,
          Row(
            children: [
              AppButton(
                child: Text(language!.lblNo, style: boldTextStyle()),
                elevation: 0,
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                child: Text(language!.lblYes, style: boldTextStyle(color: white)),
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  finish(context);

                  if (await isNetworkAvailable()) {
                    appStore.setLoading(true);

                    logoutApi().then((value) async {
                      //
                    }).catchError((e) {
                      log(e.toString());
                    });

                    await clearPreferences();

                    appStore.setLoading(false);
                    HomeScreen().launch(context, isNewTask: true);
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}

Future<void> clearPreferences() async {
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setUserProfile('');
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setLatitude(0.0);
  await appStore.setLongitude(0.0);
  await appStore.setCurrentAddress('');
  if (appStore.isCurrentLocation) {
    await appStore.setCurrentLocation(false);
  }
  await appStore.setToken('');
  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setInquiryEmail('');
  await appStore.setHelplineNumber('');
}

Future<void> logoutApi() async {
  return await handleResponse(await buildHttpResponse('logout', method: HttpMethod.GET));
}

Future<BaseResponse> changeUserPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> forgotPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethod.POST)));
}

//endregion

//region Country Api
Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethod.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}
//endregion

//region User Api
Future<DashboardResponse> userDashboard({bool isCurrentLocation = false, double? lat, double? long}) async {
  DashboardResponse? _dashboardResponse;

  if (isCurrentLocation) {
    _dashboardResponse = DashboardResponse.fromJson(
      await handleResponse(
        await buildHttpResponse('dashboard-detail?latitude=$lat&longitude=$long&${appStore.isLoggedIn ? '?customer_id=${appStore.userId.validate()}' : ''}', method: HttpMethod.GET),
      ),
    );
  } else {
    _dashboardResponse =
        DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail${appStore.isLoggedIn ? '?customer_id=${appStore.userId.validate()}' : ''}', method: HttpMethod.GET)));
  }

  if (_dashboardResponse.privacy_policy != null) {
    if (_dashboardResponse.privacy_policy!.value != null) {
      appStore.setPrivacyPolicy(_dashboardResponse.privacy_policy!.value.validate());
    } else {
      appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
    }
  } else {
    appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
  }

  if (_dashboardResponse.term_conditions != null) {
    if (_dashboardResponse.term_conditions?.value != null) {
      appStore.setTermConditions(_dashboardResponse.term_conditions!.value.validate());
    } else {
      appStore.setTermConditions(TERMS_CONDITION_URL);
    }
  } else {
    appStore.setTermConditions(TERMS_CONDITION_URL);
  }

  if (!_dashboardResponse.inquriy_email.isEmptyOrNull) {
    appStore.setInquiryEmail(_dashboardResponse.inquriy_email.validate());
  } else {
    appStore.setInquiryEmail(HELP_SUPPORT_URL);
  }
  if (!_dashboardResponse.helpline_number.isEmptyOrNull) {
    appStore.setHelplineNumber(_dashboardResponse.helpline_number.validate());
  } else {
    appStore.setHelplineNumber(HELP_SUPPORT_URL);
  }

  if (_dashboardResponse.language_option != null) {
    setValue(SERVER_LANGUAGES, jsonEncode(_dashboardResponse.language_option!.toList()));
  }

  return _dashboardResponse;
}
//endregion

//region Service Api
Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethod.POST)));
}

Future<ServiceDetailResponse> getServiceDetails({required int serviceId, int? customerId}) async {
  Map request = {CommonKeys.serviceId: serviceId, if (appStore.isLoggedIn) CommonKeys.customerId: customerId};
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethod.POST)));
}

Future<SearchResponse> getSearchListServices({
  String categoryId = '',
  String providerId = '',
  String handymanId = '',
  String isPriceMin = '',
  String isPriceMax = '',
  String search = '',
  String latitude = '',
  String longitude = '',
  String isFeatured = '',
  String subCategory = '',
  int page = 1,
}) async {
  log(subCategory);
  String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
  String searchPara = search.isNotEmpty ? 'search=$search&' : '';
  String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
  String isPriceMinPara = isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
  String isPriceMaxPara = isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
  String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
  String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
  String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
  String subCategorys = subCategory.validate().isNotEmpty
      ? subCategory != "-1"
          ? 'subcategory_id=$subCategory&'
          : ''
      : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$perPageItem';

  return SearchResponse.fromJson(await handleResponse(
    await buildHttpResponse('search-list?$categoryIds$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
  ));
}

Future<ServiceResponse> getServiceList(int page,
    {bool isCurrentLocation = false, String? searchTxt, bool isSearch = false, int? categoryId, bool isCategoryWise = false, int? customerId, double? lat, double? long}) async {
  if (isCategoryWise) {
    if (isCurrentLocation) {
      return ServiceResponse.fromJson(await handleResponse(
          await buildHttpResponse('service-list?per_page=$perPageItem&category_id=$categoryId&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    } else {
      return ServiceResponse.fromJson(
          await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&category_id=$categoryId&page=$page&customer_id=$customerId', method: HttpMethod.GET)));
    }
  } else if (isSearch) {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(await handleResponse(
          await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&search=$searchTxt&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&search=$searchTxt', method: HttpMethod.GET)));
  } else {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(
          await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId', method: HttpMethod.GET)));
  }
}
//endregion

//region Category Api
Future<CategoryResponse> getCategoryList(String page) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?page=$page&per_page=$perPageItem', method: HttpMethod.GET)));
}
//endregion

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?category_id=$catId&per_page=all', method: HttpMethod.GET)));
}
//endregion

//region Provider Api
Future<ProviderInfoResponse> getProviderDetail(int id) async {
  return ProviderInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<ProviderListResponse> getProvider({String? userType = "provider"}) async {
  return ProviderListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userType&per_page=all', method: HttpMethod.GET)));
}
//endregion

//region Handyman Api
Future<UserData> getHandymanDetail(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<BaseResponse> handymanRating(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-handyman-rating', request: request, method: HttpMethod.POST)));
}
//endregion

//region Booking Api
Future<BookingListResponse> getBookingList(int page, {var perPage = perPageItem, String status = ''}) async {
  if (status == "All") {
    return BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?&per_page=$perPage&page=$page', method: HttpMethod.GET)));
  }
  return BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethod.GET)));
}

Future<BookingDetailResponse> getBookingDetail(Map request) async {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethod.POST)));
  calculateTotalAmount(
    serviceDiscountPercent: bookingDetailResponse.service!.discount.validate(),
    qty: bookingDetailResponse.booking_detail!.quantity!.toInt(),
    detail: bookingDetailResponse.service,
    servicePrice: bookingDetailResponse.service!.price.validate(),
    taxes: bookingDetailResponse.booking_detail!.taxes.validate(),
    couponData: bookingDetailResponse.couponData,
  );
  return bookingDetailResponse;
}

Future<BaseResponse> updateBooking(Map request) async {
  BaseResponse baseResponse = BaseResponse.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethod.POST)));
  LiveStream().emit(streamUpdateBookingList);

  return baseResponse;
}

Future bookTheServices(Map request) async {
  return await handleResponse(await buildHttpResponse('booking-save', request: request, method: HttpMethod.POST));
}

Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
}
//endregion

//region Payment Api
Future<BaseResponse> savePayment(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-payment', request: request, method: HttpMethod.POST)));
}
//endregion

//region Notification Api
Future<NotificationListResponse> getNotification(Map request, {int? page = 1}) async {
  return NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list', request: request, method: HttpMethod.POST)));
}
//endregion

//region Review Api
Future<BaseResponse> updateReview(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-booking-rating', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> deleteReview({required int id}) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-booking-rating', request: {"id": id}, method: HttpMethod.POST)));
}

Future<BaseResponse> deleteHandymanReview({required int id}) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-handyman-rating', request: {"id": id}, method: HttpMethod.POST)));
}
//endregion

//region WishList Api
Future<WishListResponse> getWishlist() async {
  return WishListResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-service', method: HttpMethod.GET))));
}

Future<BaseResponse> addWishList(request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-favourite', method: HttpMethod.POST, request: request)));
}

Future<BaseResponse> removeWishList(request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-favourite', method: HttpMethod.POST, request: request)));
}
//endregion
