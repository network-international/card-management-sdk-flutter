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
      token: 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICItNzBNYURtTkxYYW1OR294SGFLWjliM0V3TmdvQ1JOOW5HenlSSFZJN3ZjIn0.eyJleHAiOjE3NzYwNzc3OTIsImlhdCI6MTc3NjA3NTk5MiwianRpIjoiYjE0NjkxMWQtNWU0NS00ZmFjLWEzZmMtY2MzMWMwODgwNGFlIiwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS1ub25wcm9kLm5ldHdvcmsuZ2xvYmFsL2F1dGgvcmVhbG1zL05JLU5vblByb2QiLCJzdWIiOiI1MjY4Mjc2ZC1iNDIwLTQ2MWYtODQ0Mi1mNTI4ZDYwZjAyMTciLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiI4ZWIyYjQxNS1hMDc4LTQ4YmQtOTUwNC0yZjQxOTU2MDVhNzk4NzAxODEiLCJzY29wZSI6InByb2ZpbGUgZW1haWwgc2Rrc2NvcGUiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInJvdXRlX2lkIjoiQVBJQyIsIlgtUkVHSU9OIjoiIiwicm9sZSI6ImJhbmsiLCJjbGllbnRJZCI6IjhlYjJiNDE1LWEwNzgtNDhiZC05NTA0LTJmNDE5NTYwNWE3OTg3MDE4MSIsIm9yZ19pZCI6Ik5JQyIsImlzUGNpRHNzIjoidHJ1ZSIsIm1pZCI6IiIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC04ZWIyYjQxNS1hMDc4LTQ4YmQtOTUwNC0yZjQxOTU2MDVhNzk4NzAxODEiLCJjaWZfaWQiOiIiLCJvcmdfY29kZSI6Ijk4MiIsImNhcmRfaWQiOiIifQ.WpKvQMt5RTzOaIiWCHc4yfRv6gS0UiEcLANep8oLdYwLhmaA-vZx5nXYNKeganiiQCnPZ79zVTVxQhNNHPN1IEEVJbegvIc2RBjpHtEnI8yPQ8lsxrmMKzXJVkPGXU3v5HzjzghXlKCERId6Dg6iTYDF9JGj0mqmc7l3N88YTrSfZtegocJ7Z_6cu60OU02aImQFEwb1hB4jt43qk7a1dKT3uqWNBCoAbuCcwhG2SffJDXvvRfOioGEIIOuUkyW4EzSvZH9vwDeIDapDsFNo1G_wsSU63jUPMudC1qoLZw_PQxEjSge5V-9qGkg6Xp-OgMHAlcwzMjuoWQMnfONqoA',
      // place url for your FI and region and environment (prod/uat) - from APIGEE
      // https://api-uat.network.global/sdk/v2
      rootUrl: 'https://apicenter-uat.network.global/api/v2/sdk/v2',
      // your FI
      bankCode: 'NIC',
      // card should be active in both - way4 and b24
      cardIdentifierId: '99985101178224453239',
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
