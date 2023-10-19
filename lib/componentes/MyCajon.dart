import 'package:elmuro/componentes/titulo_lista.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignout;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //header
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),
              // titulo
              MyListTitle(
                icon: Icons.home,
                text: 'I N I C I O',
                onTap: () => Navigator.pop(context),
              ),
              // titulo de la lista de perfiles
              MyListTitle(
                  icon: Icons.person, text: 'P E R F I L', onTap: onProfileTap),
            ],
          ),
          //cerrar seccion
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTitle(icon: Icons.logout, text: 'S A L I R', onTap: onSignout),
          ),
        ],
      ),
    );
  }
}
