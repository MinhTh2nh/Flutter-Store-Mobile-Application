import 'package:flutter/material.dart';
import '../../../components/no_account_text.dart';
import '../../../components/socal_card.dart';
import '../../consts/consts.dart';
import '../sign_in/small_components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double screenWidth = constraints.maxWidth;

                return SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.8), // Make the container slightly transparent
                      borderRadius:
                          BorderRadius.circular(10), // Apply border radius
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.8, // 80% width on larger screens
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center vertically
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              signInContinue,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const SignForm(),
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
                            const SizedBox(height: 20),
                            const NoAccountText(),
                            const SizedBox(height: 20), // Add more s
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
    );
  }
}
