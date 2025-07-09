import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget{
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 108, 108),
        shape: BoxShape.circle
      ),
    );
  }
}