import 'package:flutter/material.dart';
import '../../components/socal_card.dart';
import 'small_components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/backgroud.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double screenWidth = constraints.maxWidth;

                    return SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8), // Make the container slightly transparent
                          borderRadius: BorderRadius.circular(10), // Apply border radius
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.8, // 80% width on larger screens
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Navigate back to the previous screen
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8), // Add space between the two texts
                                const Text(
                                  "Complete your details or continue \nwith social media",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                const SignUpForm(),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SocalCard(
                                      icon: "lib/images/icons/google-icon.svg",
                                      press: () {},
                                    ),
                                    SocalCard(
                                      icon: "lib/images/icons/facebook-2.svg",
                                      press: () {},
                                    ),
                                    SocalCard(
                                      icon: "lib/images/icons/twitter.svg",
                                      press: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
