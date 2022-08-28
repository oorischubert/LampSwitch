import 'dart:convert';
import 'package:esp32test/usersettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'decor.dart';
import 'package:flutter/services.dart';
//import 'getState.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String uid = "";
  bool swValue = false; //init switch value
  bool swLoaded = false; //ProgressIndicator toggler
  Future<void> _toggleLED(ip, input) async {
    final url = ip;
    if (url != '') {
      await http.post(Uri.parse("http://$url/$input"));
    }
  }

  Future<void> _getState(ip) async {
    setState(() {
      swLoaded = false;
    });
    final url = ip;
    if (url != '') {
      final response = await http.get(Uri.parse("http://$url/S"));
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        if (decoded['state'] == 'H') {
          swValue = true;
        } else {
          swValue = false;
        }
        swLoaded = true;
      });
    }
  }

  Future _setURL(bool barrier) async {
    uid = UserSettings.getUID(); //reset uid
    showDialog(
        barrierDismissible: barrier,
        context: context,
        builder: (context) =>
            Consumer(builder: (context, UserProvider notifier, child) {
              return AlertDialog(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text('Set Address')]),
                content: TextFormField(
                  initialValue: notifier.uid,
                  decoration: InputDecoration(
                    labelText: 'ip address:',
                    enabledBorder: Decor.inputformdeco(),
                    focusedBorder: Decor.inputformdeco(),
                  ),
                  onChanged: (value) {
                    uid = value.trim();
                  },
                ),
                actions: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                        onPressed: () {
                          if (uid != "" && uid != notifier.uid) {
                            notifier.uid = uid;
                            _getState(uid);
                          }
                          if (uid != "") {
                            Navigator.pop(context);
                          }
                          if (uid == "") {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content:
                                      Text('Please input an ip address!')));
                          }
                        },
                        child: Transform.scale(
                            scale: 1.5, child: const Text('Save')))
                  ]),
                ],
              );
            }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //app state observer
    uid = UserSettings.getUID();
    (uid == "")
        ?
        //does only after widgets are built!
        WidgetsBinding.instance.addPostFrameCallback((_) => _setURL(false))
        : _getState(uid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final unPaused = state == AppLifecycleState.resumed;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) return;

    if (unPaused) {
      _getState(UserSettings.getUID());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserProvider notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lamp Switch'),
          leading: GestureDetector(
              onTap: () {
                //open info page or popup!
                _setURL(true);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: FittedBox(
                        child: Icon(
                      Icons.info_outline_rounded,
                    ))),
              )),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  _getState(notifier.uid);
                },
                child:  Padding(
                  padding: const  EdgeInsets.only(right: 20),
                  child:   Transform.scale(
                 
                      scale: 1.5,
                      child: 
                      const Icon(
                        Icons.refresh_rounded,
                      ))),
                )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: 
                  swLoaded?
                  ScaledBox(
                      height: 500,
                      width: 500,
                      child: 
                        Switch(
                              value: swValue,
                              onChanged: (_) {
                                HapticFeedback.heavyImpact();
                                setState(() {
                                  swValue = !swValue;
                                });
                                swValue
                                    ? _toggleLED(notifier.uid, 'H')
                                    : _toggleLED(notifier.uid, 'L');
                              }))
                          :  Transform.scale(scale: 6, child: const CircularProgressIndicator(),)),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
