import 'package:flutter/material.dart';
import 'package:nfc_app/Screens/tag_data_screen.dart';
import 'package:system_settings/system_settings.dart';

class MyHomePage extends StatefulWidget {
  final ValueNotifier<bool> isNfcEnabled;

  const MyHomePage({Key? key, required this.isNfcEnabled}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _requestNfcAndReadTag() async {
    if (widget.isNfcEnabled.value) {
      // Start NFC session to read the tag
      _tagRead(context);
    } else {
      // NFC is not enabled, prompt the user to enable it
      _showNfcSettingsDialog();
    }
  }

  void _tagRead(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagDataScreen(),
      ),
    );
  }


  void _showNfcSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('NFC Not Enabled'),
          content: Text('NFC is not enabled on this device. Do you want to enable it now?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemSettings.nfc();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _requestNfcAndReadTag,
              child: Text('Read Tag'),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: widget.isNfcEnabled,
              builder: (context, isEnabled, _) {
                return Text('NFC is ${isEnabled ? 'enabled' : 'disabled'}');
              },
            ),
          ],
        ),
      ),
    );
  }
}