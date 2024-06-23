import 'package:flutter_dotenv/flutter_dotenv.dart';

class KycEndpoint {
  static String baseURL = dotenv.env['API_BASE_URL']!;

  static String kyc = '$baseURL/m/v1/kyc';
}
