import 'package:flutter/material.dart';
import 'package:food_mobile_app/components/address_management.dart';
import 'package:food_mobile_app/model/customer_model.dart';
import 'package:food_mobile_app/pages/order_management.dart';
import '../../components/custome_app_bar/custom_app_bar.dart';
import '../settings/small_components/profile_menu.dart';
import '../settings/small_components/profile_pic.dart';

class Settings extends StatelessWidget {
  static String routeName = "/settings";

  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfileInformation(),
            ProfileMenu(
              text: "My Account",
              icon: "lib/images/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "Address Management",
              icon: "lib/images/address.svg",
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddressManagement(),
                ));
              },
            ),
            ProfileMenu(
              text: "My Orders",
              icon:
              "lib/images/order.svg", // Replace with your actual orders icon path
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const OrdersScreen(), // Replace with your actual OrdersScreen widget
                ));
              },
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
              press: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Adjust content padding
                      title: const Center(
                        child: Text('Log Out'), // Center the title
                      ),
                      content: Container(
                        margin: const EdgeInsets.only(bottom: 10.0), // Add margin at the bottom
                        child: const Text('Are you sure you want to log out?'),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center the buttons and add space between them
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3, // Set button width to 30% of screen width
                              child:
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // Set borderRadius to 0 for no rounding
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  // Adjust padding as needed
                                  child: Text(
                                    'Stay',
                                    style: TextStyle(
                                      fontSize: 15, // Adjust fontsize as needed
                                      color: Colors.white, // Set text color to white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3, // Set button width to 30% of screen width
                              child:
                              ElevatedButton(
                                onPressed: () async {
                                  // Perform logout action
                                  final customer = CustomerModel(email: '', password: '');
                                  await customer.logoutUser();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacementNamed(context, '/sign_in');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        0), // Set borderRadius to 0 for no rounding
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  // Adjust padding as needed
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 15, // Adjust fontsize as needed
                                      color: Colors.white, // Set text color to white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
