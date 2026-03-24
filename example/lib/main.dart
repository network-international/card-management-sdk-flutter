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
      token: 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICItNzBNYURtTkxYYW1OR294SGFLWjliM0V3TmdvQ1JOOW5HenlSSFZJN3ZjIn0.eyJleHAiOjE3NzQ2MTEwNTQsImlhdCI6MTc3NDYwOTI1NCwianRpIjoiZGZmNWRlODAtMWM5Ny00ODE5LWI4ZjItMjVhZWY0NDUxYjJmIiwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS1ub25wcm9kLm5ldHdvcmsuZ2xvYmFsL2F1dGgvcmVhbG1zL05JLU5vblByb2QiLCJzdWIiOiI1MjY4Mjc2ZC1iNDIwLTQ2MWYtODQ0Mi1mNTI4ZDYwZjAyMTciLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiI4ZWIyYjQxNS1hMDc4LTQ4YmQtOTUwNC0yZjQxOTU2MDVhNzk4NzAxODEiLCJzY29wZSI6InByb2ZpbGUgZW1haWwgc2Rrc2NvcGUiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInJvdXRlX2lkIjoiQVBJQyIsIlgtUkVHSU9OIjoiIiwicm9sZSI6ImJhbmsiLCJjbGllbnRJZCI6IjhlYjJiNDE1LWEwNzgtNDhiZC05NTA0LTJmNDE5NTYwNWE3OTg3MDE4MSIsIm9yZ19pZCI6Ik5JQyIsImlzUGNpRHNzIjoidHJ1ZSIsIm1pZCI6IiIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC04ZWIyYjQxNS1hMDc4LTQ4YmQtOTUwNC0yZjQxOTU2MDVhNzk4NzAxODEiLCJjaWZfaWQiOiIiLCJvcmdfY29kZSI6Ijk4MiIsImNhcmRfaWQiOiIifQ.Uvp4wC83AizpUzsMD0Yiuy9U1CYtG2jLUyogaDPLZitbavxfI-9s4bl8Qqguw5_EINCa9WPggIFB-j8o6Ndf5LiCWSlpPL1833F4RB0Q51AAGFEa5mu1God3OYi2t1NUwMX0R1XT7f3uzHu8kr_lbHmFN8C9QJdVQBdBWeihNzHnTpVNVdZp8WW5tsopNcIc8Ss4KQEnZV7WB-XNKjNUlkpoxk6YxTHF3EBqMA7puq928A2Q726V1gHDTDTWWRt1MVWfr4O1nqBNfYqpI6q_a-pMkTVN8YasbFiuADC-8pyCjCN3zM1TsiFcEB30zFJPzUOFIO-rBGnhcV69DWfGSA',
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
