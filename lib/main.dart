import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:location/location.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:telephony/telephony.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {};

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    onLocationChanged();
  }

  getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    return await location.getLocation();
  }

  onLocationChanged() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      for (int i = 0; i < finaList.length; i++) {
        Telephony.instance.sendSms(
            to: finaList[finaList.length - 1],
            message: "The person is at ${currentLocation.toString()}");
      }
    });
  }

  List contacts = [];
  List<bool> isSend = [];
  List finaList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        actions: [
          IconButton(
              onPressed: () {
                TextEditingController _controller1 = TextEditingController();

                TextEditingController _controller = TextEditingController();
                String phone = "";
                String name = "";
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add contact'),
                        content: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              controller: _controller1,
                              decoration: InputDecoration(
                                  hintText: "Enter the phone number to"),
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              controller: _controller,
                              decoration: InputDecoration(
                                  hintText: "Enter the name to "),
                            ),
                          ],
                        ),
                        actions: [
                          RaisedButton(
                            child: Text("Add"),
                            onPressed: () {
                              setState(() {
                                contacts.add({"name": name, "phone": phone});

                                isSend.add(true);
                              });
                              print(contacts);
                              final current = getCurrentLocation();
                              // Telephony.instance.sendSms(
                              //     to: contacts[contacts.length - 1]["phone"],
                              //     message:
                              //         "The person is at ${current.toString()}");
                            },
                          )
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add, color: Colors.white))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            children: [
              Container(
                height: 200,
                child: TextHighlight(
                  text: _text,
                  words: _highlights,
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  itemBuilder: (ctx, i) {
                    return CheckboxListTile(
                      title: Text(contacts[i]["name"]),
                      value: isSend[i],
                      onChanged: (val) {
                        setState(
                          () {
                            isSend[i] = val!;
                            if (isSend[i]) {
                              if (contacts.contains(contacts[i]["phone"])) {
                              } else {
                                finaList.add(contacts[i]["phone"]);
                              }
                              print(finaList);
                            } else {
                              finaList.remove(contacts[i]["phone"]);
                            }
                          },
                        );
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    TextEditingController _controller = TextEditingController();
    String name = "";
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Enter name'),
              content: TextField(
                onChanged: (_value) {
                  setState(() {
                    name = _value;
                  });
                },
                controller: _controller,
                decoration: InputDecoration(hintText: ""),
              ),
              actions: [
                RaisedButton(
                    child: Text("Done"),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (!_isListening) {
                        bool available = await _speech.initialize(
                          onStatus: (val) => print('onStatus: $val'),
                          onError: (val) => print('onError: $val'),
                        );
                        if (available) {
                          setState(() => _isListening = true);
                          _speech.listen(
                            onResult: (val) => setState(() async {
                              _text = val.recognizedWords;
                              if (_text
                                  .toLowerCase()
                                  .contains(name.toLowerCase())) {
                                print("Found the name");
                                bool canVibrate = await Vibrate.canVibrate;

                                Vibrate.vibrate();

                                final Iterable<Duration> pauses = [
                                  const Duration(milliseconds: 500),
                                  const Duration(milliseconds: 1000),
                                  const Duration(milliseconds: 500),
                                ];
                                Vibrate.vibrateWithPauses(pauses);
                              }
                              if (val.hasConfidenceRating &&
                                  val.confidence > 0) {
                                _confidence = val.confidence;
                              }
                            }),
                          );
                        }
                      } else {
                        setState(() => _isListening = false);
                        _speech.stop();
                      }
                    })
              ]);
        });
  }
}
