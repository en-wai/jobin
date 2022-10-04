class AppConstants {
  static const String APP_NAME = 'DBFood';
  static const int APP_VERSION = 1;
  //https://youtu.be/HCUZ91NVnaM learn here how to set up google map api key
  static const String MAP_API_KEY="your google map api key";
  static const String STORE_PREFERENCE='Cart-list';
  //your base url
  //https://youtu.be/DjXS9W1HD9U here how to set up the admin panel
  static const String BASE_URL = '';
  static const String REGISTER_URI = '/api/v1/auth/register';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String TOPIC = 'all_zone_customer';
  static const String ZONE_ID = 'zoneId';
  static const String UPLOADS_URL =BASE_URL+'/uploads/';

  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String USER_COUNTRY_CODE = 'user_country_code';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String REMOVE_ADDRESS_URI = '/api/v1/customer/address/delete?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';

  static const String POPULAR_PRODUCT_URI = '/api/v1/products/popular';
  static const String TOKEN = 'dbshop_token';
  static const String RECOMMENDED_PRODUCT_URI = '/api/v1/products/recommended';
  static const String RECOMMENDED_PRODUCT_URI_TEST = '/api/v1/products/test';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';
  static const String ORDER_CANCEL_URI = '/api/v1/customer/order/cancel';
  static const String COD_SWITCH_URL = '/api/v1/customer/order/payment-method';
  static const String ORDER_DETAILS_URI = '/api/v1/customer/order/details?order_id=';
  static const String TRACK_URI = '/api/v1/customer/order/track?order_id=';

}