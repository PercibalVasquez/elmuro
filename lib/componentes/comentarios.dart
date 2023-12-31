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
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comentario
          Text(text),
          const SizedBox(
            height: 5,
          ),
          //usuario y hora
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(" . ", style: TextStyle(color: Colors.grey[400])),
              Text(time, style: TextStyle(color: Colors.grey[400]))
            ],
          ),
        ],
      ),
    );
  }
}
