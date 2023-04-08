import 'package:flutter/material.dart';

class PantVacia extends StatefulWidget {
  final String title;

  const PantVacia({super.key, required this.title});

  @override
  State<PantVacia> createState() => _PantVaciaState();
}

class _PantVaciaState extends State<PantVacia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Text('Pantalla Vacía del menu ${widget.title}'),
      )),
    );
  }
}
