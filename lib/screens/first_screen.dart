// first_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../bluetooth/scan_screen.dart';
import 'contect_screen.dart';
import 'help_screen.dart';

class FirstScreen extends StatefulWidget {
  static const String routeName = "FirstScreen";
  final BluetoothDevice? device;
  final BluetoothCharacteristic? characteristic;

  const FirstScreen({super.key, this.device, this.characteristic});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _isLoading = true;
  GlobalKey<SliderDrawerState> _sliderDrawerKey = GlobalKey<SliderDrawerState>();
  bool isConnected = false;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? controlCharacteristic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isLoading = false;
        connectedDevice = widget.device;
        controlCharacteristic = widget.characteristic;
        isConnected = connectedDevice != null && controlCharacteristic != null;
      });
    });
  }

  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      setState(() {
        connectedDevice = null;
        controlCharacteristic = null;
        isConnected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected from device', style: TextStyle(color: Colors.white))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SliderDrawer(
              key: _sliderDrawerKey,
              appBar: SliderAppBar(
                config: SliderAppBarConfig(
                  title: Text(
                    "Control",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff7B88E0),
                    ),
                  ),
                ),
              ),
              sliderOpenSize: screenWidth * 0.55,
              slider: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg3.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),
                    CircleAvatar(
                      radius: screenWidth * 0.18,
                      backgroundColor: Colors.transparent,
                      backgroundImage: const AssetImage("assets/xx/ic2-removebg-preview.png"),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Divider(
                      color: Colors.white70,
                      thickness: 2,
                      indent: screenWidth * 0.1,
                      endIndent: screenWidth * 0.1,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScanScreen(
                              onConnect: (bool connected) {
                                setState(() {
                                  isConnected = connected;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth * 0.13,
                              height: screenWidth * 0.13,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(Icons.bluetooth, size: screenWidth * 0.07, color: const Color(0xffa1dacb)),
                            ),
                            Text(
                              "Bluetooth ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
                      child: ListTile(
                        leading: Icon(Icons.help, color: Colors.white, size: screenWidth * 0.08),
                        title: Text(
                          "Help",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        onTap: () {
                          Navigator.pushNamed(context, HelpScreen.routeName);
                        },
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.05),
                      child: Text(
                        "By Mahmoud Elshikh",
                        style: TextStyle(color: Colors.white70, fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: ContectScreen(
                    connectedDevice: connectedDevice,
                    characteristic: controlCharacteristic,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.025,
              right: screenWidth * 0.05,
              child: GestureDetector(
                onTap: () {
                  if (isConnected) {
                    disconnectDevice();
                  }
                },
                child: Container(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isConnected ? Colors.green : Colors.red,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    color: isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}