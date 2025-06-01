import 'package:flutter/material.dart';

void mostrarMensajeError(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              mensaje,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      });
}
