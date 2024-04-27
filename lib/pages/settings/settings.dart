import 'package:flutter/material.dart';

import '../../components/custome_app_bar/custom_app_bar.dart';
import '../settings/small_components/profile_menu.dart';
import '../settings/small_components/profile_pic.dart';

class Settings extends StatelessWidget {
  static String routeName = "/settings";

  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "lib/images/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "lib/images/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "lib/images/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "lib/images/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "lib/images/Log out.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}