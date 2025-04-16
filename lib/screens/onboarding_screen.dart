import 'package:flutter/material.dart';
import 'first_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = "/";

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Center(
                    child: Image.asset(
                      "assets/images/cRM.png",
                      height: screenHeight * 0.9,
                      width: screenWidth * 0.9,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  children: [
                    Text(
                      "Easily interact with your robot using voice commands",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff7B88E0),
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      height: screenHeight * 0.015,
                      color: const Color(0xff7B88E0),
                      endIndent: screenWidth * 0.08,
                      indent: screenWidth * 0.08,
                    ),
                    Text(
                      "Say the command, and let the robot do the rest",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff7B88E0),
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      FirstScreen.routeName,
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7B88E0),
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Getting Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}