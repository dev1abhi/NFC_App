import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:system_settings/system_settings.dart';

import 'Screens/Homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ValueNotifier<bool> isNfcEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _checkNfcStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNfcStatus();
    }
  }

  Future<void> _checkNfcStatus() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        isNfcEnabled.value = true;
      } else {
        isNfcEnabled.value = false;
      }
    } catch (e) {
      print('Error checking NFC status: $e');
      isNfcEnabled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(isNfcEnabled: isNfcEnabled),
    );
  }
}


