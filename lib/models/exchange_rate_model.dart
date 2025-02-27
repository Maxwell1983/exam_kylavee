import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';


class ExchangeRateModel {
  String baseCurrency = 'USD';
  String targetCurrency = 'EUR';
  double? exchangeRate;
  DateTime? lastUpdated;

  Future<void> fetchExchangeRate() async {
    // Replace with your actual API endpoint including your API key
    final url = 'https://v6.exchangerate-api.com/v6/$exchangeRateApiKey/latest/$baseCurrency';
    print('Making API call to: $url');  // Log the API call
    final response = await http.get(Uri.parse(url));

    print('Received response with status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API response: $data');
      if (data['result'] == 'success') {
        // Extract the rate for the target currency
        exchangeRate = data['conversion_rates'][targetCurrency];
        // Parse the last updated time (using the Unix timestamp)
        lastUpdated = DateTime.fromMillisecondsSinceEpoch(data['time_last_update_unix'] * 1000);
      } else {
        // Handle error according to your app's requirements
        print("Error: API call did not return success");
      }
    } else {
      // Handle network errors
      print("Error: HTTP request failed");
    }
  }
}
