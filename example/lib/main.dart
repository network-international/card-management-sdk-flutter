import 'package:flutter/material.dart';
import 'package:card_management_sdk/card_management_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _sdk = CardManagementSdk();

  String _cardDetailsResult = '';
  String _setPinResult = '';

  @override
  void initState() {
    super.initState();
    _initSdk();
  }

  Future<void> _initSdk() async {
    /**
final sdk = CardManagementSdk();
await sdk.initialize(token: '...', rootUrl: '...', bankCode: '...', cardIdentifierId: '...', cardIdentifierType: '...');
final details = await sdk.getCardDetails();  // Map with clearPan, maskedPan, expiry, etc.
await sdk.setPin('1234');
await sdk.verifyPin('1234');
await sdk.changePin('1234', '5678');
final pin = await sdk.getPin();
     */
    await _sdk.initialize(
      // use https://api-uat.network.global/v1/tokenkc/generate
      // and generate new token with your clientId/secred credentials
      token: 'TOKEN',
      // place url for your FI and region and environment (prod/uat) - from APIGEE
      // https://api-uat.network.global/sdk/v2
      rootUrl: 'https://<host>/sdk/v2',
      // your FI
      bankCode: 'FI',
      // card should be active in both - way4 and b24
      cardIdentifierId: '1234566',
      cardIdentifierType: 'EXID',
      debugLogToConsole: true, // false
      extraNetworkHeaders: {"custom_header": "Additional value"}, // null
    );
  }

  Future<void> _fetchCardDetails() async {
    try {
      final result = await _sdk.getCardDetails();
      setState(() {
        _cardDetailsResult = result?.toString() ?? 'No data';
      });
    } catch (e) {
      setState(() {
        _cardDetailsResult = 'Error: $e';
      });
    }
  }

  Future<void> _setPin() async {
    try {
      await _sdk.setPin('1234');
      setState(() {
        _setPinResult = 'Success';
      });
    } catch (e) {
      setState(() {
        _setPinResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Management SDK')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _fetchCardDetails,
              child: const Text('Card Details'),
            ),
            const SizedBox(height: 8),
            Text(
              _cardDetailsResult,
              maxLines: null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _setPin,
              child: const Text('Set Pin'),
            ),
            const SizedBox(height: 8),
            Text(_setPinResult),
          ],
        ),
      ),
    );
  }
}
