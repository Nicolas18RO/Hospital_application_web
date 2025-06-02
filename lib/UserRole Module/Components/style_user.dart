import 'package:flutter/material.dart';
import 'package:hospital_gestion_application/Components/Widgets/my_text.dart';

class AccountUser extends StatelessWidget {
  final String textIcon;
  const AccountUser({super.key, required this.textIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 80,
      child: Column(
        children: [
          const Icon(Icons.account_circle, size: 65),
          MyText(texto: textIcon, fontSizeText: 15, color: Colors.black)
        ],
      ),
    );
  }
}
