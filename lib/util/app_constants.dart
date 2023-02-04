
import 'package:abaad/data/model/response/language_model.dart';
import 'package:abaad/util/images.dart';
class AppConstants {
  static const String APP_NAME = 'Baad';
  static const double APP_VERSION = 1.0;
  static const String LOGIN_URI = '/api/v1/auth/login';
 // static const String BASE_URL = 'http://alharthi.iaspl.net';
  static const String BASE_URL = 'http://192.168.159.37/abbaad-dashboard';
  static const String REGISTER_URI = '/api/v1/auth/register';
  static const String THEME = 'theme';
  static const String TOKEN = 'abaad_token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  // static const String ZONE_ID = 'zoneId';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String USER_ADDRESS = 'user_address';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String TOPIC = 'all_zone_customer';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_NUMBER = 'user_number';
  static const String USER_COUNTRY_CODE = 'user_country_code';
  static const String NOTIFICATION = 'notification';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
  static const String UPDATE_ZONE_URL = '/api/v1/customer/update-zone';
  static const String ZONE_LIST_URI = '/api/v1/zone/list';
  static const String SEARCH_HISTORY = 'search_history';
  static const String INTRO = 'intro';
  static const String NOTIFICATION_COUNT = 'notification_count';
  static const String CONFIG_URI = '/api/v1/config';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String REMOVE_ADDRESS_URI = '/api/v1/customer/address/delete?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  static const String SEARCH_LOCATION_URI = '/api/v1/config/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String CATEGORIES = '/api/v1/categories';
  static const String CATEGORY_ESTATEURI = '/api/v1/estate/get-estate';
  static const String ZONE_ALL = '/api/v1/zones';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';
  static const String BANNER_URI = '/api/v1/banners';
  static const String NOTIFICATION_URI = '/api/v1/customer/notifications';
  static const String ESTATE_DETAILS_URI = '/api/v1/estate/details/';


  static List<int> tips = [0, 5, 10, 15, 20, 30, 50];


  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  ];
}
