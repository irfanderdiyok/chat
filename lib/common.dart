import 'package:flutter/material.dart';

class MyFunction {
  static void changePage(StatefulWidget statefulWidget, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
    );
  }

  static void changePagePushReplacement(
      StatefulWidget statefulWidget, BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
    );
  }
}

class Common {
  Future showLoading(BuildContext context, BuildContext popUp) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          popUp = context;
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  Future showErrorDialog(
      String errorTitle, String errorText, BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(errorTitle),
            content: Text(errorText),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Kapat'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
