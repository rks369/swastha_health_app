import 'package:flutter/material.dart';

changeScreen(BuildContext context, Widget sceeen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => sceeen));
}

changeScreenReplacement(BuildContext context, Widget sceeen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => sceeen));
}
