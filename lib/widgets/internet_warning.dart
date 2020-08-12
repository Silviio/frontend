import 'package:avaliacao/resources/string_value.dart';
import 'package:flutter/material.dart';

class InternetWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 100,
                height: 100,
                child: Image.asset(Strings.robotImage)),
            SizedBox(
              height: 8.0,
            ),
            Text(
              Strings.internetWarning,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Spartan MB',
                  color: Colors.grey[800],
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(Strings.checkConnection,
                style: TextStyle(
                    fontFamily: 'Spartan MB',
                    color: Colors.grey[800],
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
