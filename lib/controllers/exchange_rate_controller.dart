import '../models/exchange_rate_model.dart';

class ExchangeRateController {
  final ExchangeRateModel model;

  ExchangeRateController(this.model);

  /// Calls the model to fetch the latest exchange rate.
  Future<void> refreshExchangeRate() async {
    await model.fetchExchangeRate();
  }

  /// Updates the selected currencies and refreshes the exchange rate.
  void updateCurrencyPair(String newBase, String newTarget) {
    model.baseCurrency = newBase;
    model.targetCurrency = newTarget;
    refreshExchangeRate();
  }
}
