import 'dart:convert';
import 'package:esp32test/usersettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
//import 'decor.dart';

//<><><><><><><><><><><><><><><><><><><>
//          CODE NOT IN USE
//<><><><><><><><><><><><><><><><><><><>

class TextSend extends StatefulWidget {
  @override
  _TextSendState createState() => _TextSendState();
}

class _TextSendState extends State<TextSend> {
  String uid = "";
  String message = "";
  bool lampState = false;

  Future<void> _sendText(ip, input) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final url = ip;
      if (url != '') {
        final response = await http.get(Uri.parse("http://$url/$input"));
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          if (decoded['state'] == 'H') {
            lampState = true;
          } else {
            lampState = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receiving Json')),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              lampState
                  ? const Text(
                      'Lamp is On',
                      style: TextStyle(color: Colors.green, fontSize: 30),
                    )
                  : const Text('Lamp is Off',
                      style: TextStyle(color: Colors.red, fontSize: 30)),
              const Spacer(),
              SizedBox(
                  height: 150,
                  width: 300,
                  child: FittedBox(
                      child: TextButton(
                          onPressed: () {
                            _sendText(notifier.uid, "S");
                          },
                          child: const Text('Send!')))),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
