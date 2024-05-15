import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AwesomeSnackBarExample extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final ContentType contentType;
  final bool inMaterialBanner;
  final IconData customIcon;

  const AwesomeSnackBarExample({
    Key? key,
    required this.title,
    required this.message,
    required this.color,
    required this.contentType,
    required this.inMaterialBanner,
    required this.customIcon,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Show Awesome SnackBar'),
              onPressed: () {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: title,
                    message: message,
                    contentType: contentType,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
            ),
          ],
        ),
      ),
    );
  }
}
