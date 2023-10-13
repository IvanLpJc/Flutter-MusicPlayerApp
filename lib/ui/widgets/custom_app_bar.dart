import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(
          top: 30,
        ),
        child: const Row(
          children: [
            FaIcon(FontAwesomeIcons.chevronLeft),
            Spacer(),
            FaIcon(FontAwesomeIcons.message),
            SizedBox(
              width: 20,
            ),
            FaIcon(FontAwesomeIcons.headphonesSimple),
            SizedBox(
              width: 20,
            ),
            FaIcon(FontAwesomeIcons.arrowUpRightFromSquare),
          ],
        ),
      ),
    );
  }
}
