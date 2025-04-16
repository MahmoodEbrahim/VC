import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  static const String routeName = "HelpScreen";

  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "How to Use the App",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black87,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      "Step 1: Turn on the Robot",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Divider(color: Colors.white70, thickness: 1, indent: screenWidth * 0.1, endIndent: screenWidth * 0.1),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      "Step 2: Connect via Bluetooth",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Image.asset("assets/xx/Capture20.PNG", height: screenHeight * 0.15),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      "Press it to turn on the Bluetooth and if he pressed it again it will disconnect it",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Divider(color: Colors.white70, thickness: 1, indent: screenWidth * 0.1, endIndent: screenWidth * 0.1),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      "Step 3: Press this icon to give voice commands in Home Screen",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/xx/Capture111.PNG",
                                  height: screenHeight * 0.18,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "You can \n control",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 20.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_circle_right,
                            color: Colors.white,
                            size: screenWidth * 0.12,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/xx/Capture2222.PNG",
                                  height: screenHeight * 0.2,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  "You can \n Stop",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 20.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Divider(color: Colors.white70, thickness: 1, indent: screenWidth * 0.1, endIndent: screenWidth * 0.1),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Step 4: Press this icon to Change to control with Remote",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Image.asset("assets/images/Capture10.PNG", height: screenHeight * 0.2),
                    SizedBox(height: screenHeight * 0.015),
                    Divider(color: Colors.white70, thickness: 1, indent: screenWidth * 0.1, endIndent: screenWidth * 0.1),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Step 5: Now can control with Remote in Home Screen",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Image.asset("assets/images/Capture11.PNG", height: screenHeight * 0.2),
                    SizedBox(height: screenHeight * 0.015),
                    Divider(color: Colors.white70, thickness: 1, indent: screenWidth * 0.1, endIndent: screenWidth * 0.1),
                    SizedBox(height: screenHeight * 0.015),
                    Text(
                      "Step 6: Here the connection status is displayed and you can click on it to disconnect if you are connected.",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Image.asset("assets/xx/CaptureOFF.PNG", height: screenHeight * 0.2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}