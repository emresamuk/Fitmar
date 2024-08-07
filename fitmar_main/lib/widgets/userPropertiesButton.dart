import 'package:flutter/material.dart';

class OldScreenButton {
  OldScreenButton();

  buildNextButton(BuildContext context, String text, MaterialPageRoute route) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 50),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 10, 61, 113),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(context, route);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded), 
            color: Colors.white, 
            iconSize: 40, 
          ),
        ),
      ),
    );
  }
}
