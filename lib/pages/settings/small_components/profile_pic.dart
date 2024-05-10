import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileInformation extends StatelessWidget {

  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: storage.read(key: 'email').then((value) => value ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final email = snapshot.data ?? ''; // Get email from snapshot or set default value
          return Container(
            padding: EdgeInsets.all(10),
            color: Colors.teal.shade200, // Background color
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/images/admin_avtar.jpg'),
                ),
                SizedBox(width: 20), // Add spacing between CircleAvatar and information
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5), // Add spacing between designation and icon

                    InkWell(
                      onTap: () {
                        // Add functionality for the message icon
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), // Adding padding to the container
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1),
                          color: Colors.white, // Background color
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15), // Adding space between Text and Icon
                              child: Text(
                                "Member",
                                style: TextStyle(fontSize: 10 , color: Colors.blueGrey), // Setting font size
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10, // Setting font size
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10), // Add spacing between icon and info containers
                    Row(
                      children: [
                        _buildInfoContainer('0', 'Following'),
                        SizedBox(width: 20), // Add space between the two info containers
                        _buildInfoContainer('30', 'Followers'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

Widget _buildInfoContainer(String value, String label) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              SizedBox(width: 5), // Add spacing between icon and info containers
              Text(
                label,
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ],
    ),
  );

}
