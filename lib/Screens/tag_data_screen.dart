
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TagDataScreen extends StatefulWidget {
  @override
  _TagDataScreenState createState() => _TagDataScreenState();
}

class _TagDataScreenState extends State<TagDataScreen> {
  late Future<void> _nfcSession;

  String? tagData;

  @override
  void initState() {
    super.initState();
    _nfcSession = _startNfcSession();
  }

  Future<void> _startNfcSession() async {
    try {
      await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) {
        setState(() {
          // ValueNotifier<dynamic> result = ValueNotifier(null);
          // result.value = tag.data;

          // print('value =$result');
          // tag.data.keys.forEach((element) {
          //   print('key =$element');
          // });
          List<List<int>> identifiers = [];
          var identifier;
          tag.data.values.forEach((element) {
            if (element.containsKey('identifier')) {
              identifiers.add(element['identifier']);
            }
          });

          if (identifiers.isNotEmpty) {
             identifier = identifiers.first;
            print('identifier value = $identifier');
          }

          String serialNumber = convertToSerialNumber(identifier);
          tagData = serialNumber;

          // tag.data.entries.forEach((element) {
          //   print('entry =$element');
          // });

        });
        NfcManager.instance.stopSession();
        return Future.value();
      });
    } catch (e) {
      print('Error starting NFC session: $e');
      //rethrow;

    }
  }


  String convertToSerialNumber(List<int> identifier) {
    List<String> hexStrings = identifier.map((int value) => value.toRadixString(16).padLeft(2, '0')).toList();
    String serialNumber = hexStrings.join(':');
    return serialNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Tag Data'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _nfcSession,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: () {
                  if (tagData != null) {
                    if (tagData == 'a2:5f:59:20') {
                      return Text(
                        'Hello , Abhilash !',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      );
                    }
                     else if (tagData == 'a2:63:62:20') {
                      return Text(
                        'Hello , DibyaShakti ! How are you ?',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      );
                    }
                    else if (tagData == '73:e0:a0:2d') {
                      return Text(
                        'Hello , Rihan ! How are you ?',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      );
                    }

                    else {
                      return Text(
                        'NFC Tag Data: $tagData',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      );
                    }
                  } else {
                    return Text(
                      'No NFC Tag Data found.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  }
                }(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }
}
