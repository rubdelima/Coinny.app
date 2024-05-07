import 'package:flutter/material.dart';
import 'package:learn/classes.dart';
import 'package:learn/components/streak.dart';
import 'package:learn/utils.dart';

class UserPhotoAndName extends StatelessWidget {
  final Person person;
  final bool isSugestion;
  final bool logout;

  const UserPhotoAndName({
    required this.person,
    this.isSugestion = false,
    this.logout = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Children? child = person is Children ? person as Children : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(person.photoPath, height: 60),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${isSugestion ? person.name : "Olá"}\n",
                style: TextStyle(
                  fontSize: isSugestion ? 18 : 14,
                  fontWeight: isSugestion ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              TextSpan(
                text: isSugestion
                    ? "${child!.getLevel()} ${child.getClass()}"
                    : person.name,
                style: TextStyle(
                  fontSize: isSugestion ? 14 : 18,
                  fontWeight: isSugestion ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ],
            style: TextStyle(
              color: isSugestion ? const Color(0xFF0D116E) : Colors.white,
              fontFamily: "Fieldwork-Geo",
            ),
          ),
        ),
        const Spacer(),
        person is Children
            ? isSugestion
                ? child!.getShield()
                : StreakWidget(child: person as Children)
            : const SizedBox(),
        if (logout)
          IconButton(
              onPressed: () {
                clearLocalPerson();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
      ],
    );
  }
}
