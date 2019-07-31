import 'api_config_detail.dart';
import 'api_config_type.dart';

class ApiConfig {
  static ApiConfigDetail createConnectionDetail(ApiConfigType type) {
    ApiConfigDetail connection = new ApiConfigDetail();
    if (type == null) {
      type = ApiConfigType.DEVELOP;
    }
    switch (type) {
      case ApiConfigType.DEVELOP:
        connection.setBaseUrl("https://api.themoviedb.org/3/");
        connection.setApiKey("ee8cf966d22254270f6faa1948ecf3fc");
        break;
      case ApiConfigType.STAGING:
        break;
      case ApiConfigType.PRELIVE:
        break;
      case ApiConfigType.LIVE:
        break;
      default:
        break;
    }
    return connection;
  }
}
