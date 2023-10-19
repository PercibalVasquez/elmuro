import 'package:elmuro/auth/login_or_register.dart';
import 'package:elmuro/paginas/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Escuchar cambios en el estado de autenticación utilizando Firebase Authentication.
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Comprobar si un usuario ha iniciado sesión.
          if (snapshot.hasData) {
            return const HomePage(); // Si hay un usuario autenticado, muestra la página de inicio.
          }
          // Usuario no ha iniciado sesión.
          else {
            return const LoginOrRegister(); // Si no hay usuario autenticado, muestra la página de inicio de sesión o registro.
          }
        },
      ),
    );
  }
}
