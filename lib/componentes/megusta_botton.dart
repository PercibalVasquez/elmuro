import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLike;
  void Function()? onTap;
  LikeButton({super.key, required this.isLike, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon( 
      isLike ? Icons.favorite : Icons.favorite_border,
      color: isLike ? Colors.red : Colors.grey ,
      ),
    );
  }
}