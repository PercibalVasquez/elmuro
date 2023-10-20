import 'package:flutter/material.dart';

class Coment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Coment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          //comentario
          Text(text),
          //usuario y hora
          Row(
            children: [Text(user), const Text(" . "), Text(time)],
          )
        ],
      ),
    );
  }
}
