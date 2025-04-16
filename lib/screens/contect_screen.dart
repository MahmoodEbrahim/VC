import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ContectScreen extends StatefulWidget {
  static const String routeName = "ContectScreen";
  final BluetoothDevice? connectedDevice;
  final BluetoothCharacteristic? characteristic;

  final Function(BluetoothDevice?)? onDeviceUpdate;
  const ContectScreen({
    super.key,
    this.connectedDevice,
    this.characteristic,
    this.onDeviceUpdate,
  });
  @override
  State<ContectScreen> createState() => _ContectScreenState();
}

class _ContectScreenState extends State<ContectScreen> {
  String imagePath = "assets/images/Shapes Design2.png";
  bool isPlaying = false;

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  Future<void> requestMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      print("🎤 Microphone permission granted.");
    } else {
      print("❌ Microphone permission denied.");
    }
  }
  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();

    connectedDevice = widget.connectedDevice;
    if (connectedDevice != null) {
      discoverServices(connectedDevice!);
    }
    _speech = stt.SpeechToText();
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    var services = await device.discoverServices();

    for (var service in services) {
      print("Service: ${service.uuid}");
      for (var c in service.characteristics) {
        print("  Characteristic: ${c.uuid} | Props: ${c.properties}");
      }
    }

    for (var service in services) {
      if (service.uuid.toString() == '0000ffe0-0000-1000-8000-00805f9b34fb') {
        for (var c in service.characteristics) {
          if (c.properties.write) {
            characteristic = c;
            print("Writable Characteristic Found: ${c.uuid}");
            _showSuccessDialog(context, c.uuid.toString());
            return;
          }
        }
      }
    }

    if (characteristic == null) {
      for (var service in services) {
        for (var c in service.characteristics) {
          if (c.properties.write) {
            characteristic = c;
            print("Fallback Characteristic Found: ${c.uuid}");
            _showSuccessDialog(context, c.uuid.toString());
            return;
          }
        }
      }
    }

    if (characteristic == null) {
      print("❌ No writable characteristic found.");
      _showErrorDialog(context);
    }
  }

  Future<void> sendCommand(String command) async {
    try {
      if (characteristic == null) {
        print("❌ Characteristic is null. Can't send command.");
        return;
      }
      List<int> commandBytes = command.codeUnits;
      print("✅ Sending command: $command | Bytes: $commandBytes");
      await characteristic!.write(commandBytes, withoutResponse: true);
      await Future.delayed(Duration(milliseconds: 50));
    } catch (e) {
      print("Error sending command: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending command: $e')),
        );
      }
    }
  }

  void _listen() async {
    print("🎤 Trying to listen...");

    if (!_isListening && isPlaying) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('🎙️ Speech status: $val');
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
            _speech.stop();
          }
        },
        onError: (val) => print('❌ Speech error: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        print("✅ Speech initialized. Listening...");

        _speech.listen(
          localeId: 'ar_EG',
          listenMode: stt.ListenMode.dictation,
          partialResults: false,
          listenFor: Duration(seconds: 5000), // مدة الاستماع
          pauseFor: Duration(seconds: 20000),   // مهلة بعد السكوت
          onResult: (val) {
            String text = val.recognizedWords.toLowerCase();
            print("🎤 Recognized: $text");

            if (text.contains("الأمام") || text.contains("forward") || text.contains("اذهب") || text.contains("go")) {
              sendCommand("FORWARD");
            } else if (text.contains("الخلف") || text.contains("backward") || text.contains("ارجع") || text.contains("back")) {
              sendCommand("BACKWARD");
            } else if (text.contains("يمين") || text.contains("right")) {
              sendCommand("RIGHT");
            } else if (text.contains("يسار") || text.contains("left")) {
              sendCommand("LEFT");
            } else if (text.contains("توقف") || text.contains("stop") || text.contains("قف")) {
              sendCommand("STOP");
            } else {
              print("❓ No valid command detected.");

            }
          },
        );
      } else {
        print("⚠️ Speech initialization failed!");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل في تهيئة التعرف على الصوت')),
          );
        }
      }
    } else if (_isListening && !isPlaying) {
      print("🛑 Stopping listening...");
      await _speech.stop();
      setState(() => _isListening = false);
      sendCommand("STOP");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/bg1.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: screenHeight * 0.12,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/Union3.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset("assets/images/Subtract.png"),
            ),
            Positioned(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: Image.asset(
                "assets/images/Ellipse 8.png",
                height: screenHeight * 0.35,
                width: screenWidth * 0.9,
              ),
            ),
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              child: CircleAvatar(
                radius: screenWidth * 0.3,
                backgroundImage: AssetImage("assets/images/Ellipse 9.png"),
              ),
            ),
            Positioned(
              bottom: 0,
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    imagePath = imagePath == "assets/images/Shapes Design2.png"
                        ? "assets/xx/remteC.png"
                        : "assets/images/Shapes Design2.png";
                  });
                },
                child: Image.asset(
                  imagePath,
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.32,
              left: screenWidth * 0.08,
              right: screenWidth * 0.05,
              child: imagePath == "assets/images/Shapes Design2.png"
                  ? GestureDetector(
                onTap: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    print("🎮 isPlaying: $isPlaying");
                    _listen();
                  });
                },
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                  size: screenWidth * 0.55,
                  color: Colors.black,
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward_sharp, size: screenWidth * 0.12),
                    onPressed: () {
                      print("⬆️ Forward Pressed");
                      sendCommand("FORWARD");
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: screenWidth * 0.12),
                        onPressed: () {
                          print("⬅️ Left Pressed");
                          sendCommand("LEFT");
                        },
                      ),
                      SizedBox(width: screenWidth * 0.08),
                      GestureDetector(
                        onTap: () {
                          print("🛑 Stop Pressed");
                          sendCommand("STOP");
                        },
                        child: Image.asset("assets/xx/offB.png", height: screenHeight * 0.12),
                      ),
                      SizedBox(width: screenWidth * 0.08),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded, size: screenWidth * 0.12),
                        onPressed: () {
                          print("➡️ Right Pressed");
                          sendCommand("RIGHT");
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  IconButton(
                    icon: Icon(Icons.arrow_downward_outlined, size: screenWidth * 0.12),
                    onPressed: () {
                      print("⬇️ Backward Pressed");
                      sendCommand("BACKWARD");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String uuid) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(screenWidth * 0.05),
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.1),
          content: SizedBox(
            width: screenWidth * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.08),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      "Characteristic Found!",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Success: A writable characteristic was found.",
                  style: TextStyle(color: Colors.black87, fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "UUID: $uuid",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.05)),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(screenWidth * 0.05),
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.1),
          content: SizedBox(
            width: screenWidth * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: screenWidth * 0.08),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      "Problem Detected!",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Problem: No writable characteristic found.",
                  style: TextStyle(color: Colors.black87, fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Solution: Check the robot's documentation for the correct UUID or ensure it supports writable characteristics.",
                  style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.035),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
