import 'package:flutter/material.dart';
import '../models/exchange_rate_model.dart';
import '../controllers/exchange_rate_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExchangeRateModel _model;
  late ExchangeRateController _controller;
  // A sample list of currencies for selection
  final List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY'];

  @override
  void initState() {
    super.initState();
    // Instantiate the model and controller
    _model = ExchangeRateModel();
    _controller = ExchangeRateController(_model);
    // Load the initial exchange rate data
    _controller.refreshExchangeRate().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await _controller.refreshExchangeRate();
              setState(() {}); // Update the UI after refreshing data
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the current currency pair
              Text(
                '${_model.baseCurrency} to ${_model.targetCurrency}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              // Display the exchange rate or a loading indicator
              _model.exchangeRate != null
                  ? Text(
                _model.exchangeRate!.toStringAsFixed(2),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )
                  : CircularProgressIndicator(),
              SizedBox(height: 20),
              // Display the last updated time if available
              if (_model.lastUpdated != null)
                Text(
                  'Last updated: ${_model.lastUpdated!.toLocal()}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              SizedBox(height: 40),
              // Bonus: Dropdown menus to allow the user to change the currency pair
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dropdown for the base currency
                  DropdownButton<String>(
                    value: _model.baseCurrency,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newBase) async {
                      if (newBase != null) {
                        // Use the controller to update the currency pair and refresh data
                        _controller.updateCurrencyPair(newBase, _model.targetCurrency);
                        await _controller.refreshExchangeRate();
                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(width: 20),
                  // Dropdown for the target currency
                  DropdownButton<String>(
                    value: _model.targetCurrency,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newTarget) async {
                      if (newTarget != null) {
                        _controller.updateCurrencyPair(_model.baseCurrency, newTarget);
                        await _controller.refreshExchangeRate();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
