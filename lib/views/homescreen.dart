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
      // Optionally, you can remove the AppBar if not needed
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        // Use BoxDecoration to add a background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            // SingleChildScrollView ensures content is scrollable on smaller devices.
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Big golden dollar sign at the top
                  Icon(
                    Icons.attach_money,
                    size: 100,
                    color: Colors.amber,
                  ),
                  SizedBox(height: 16),
                  // "Currency Exchange" text
                  Text(
                    'Currency Exchange',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Refresh button placed under the title
                  ElevatedButton(
                    onPressed: () async {
                      await _controller.refreshExchangeRate();
                      setState(() {});
                    },
                    child: Icon(Icons.refresh),
                  ),
                  SizedBox(height: 30),
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
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  )
                      : CircularProgressIndicator(),
                  SizedBox(height: 20),
                  // Display the last updated time if available
                  if (_model.lastUpdated != null)
                    Text(
                      'Last updated: ${_model.lastUpdated!.toLocal()}',
                      style:
                      TextStyle(fontSize: 14, color: Colors.green[600]),
                    ),
                  SizedBox(height: 40),
                  // Dropdown menus to allow the user to change the currency pair
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
        ),
      ),
    );
  }
}
