import 'package:elmuro/componentes/button.dart';
import 'package:elmuro/componentes/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //iniciar seccion
  void inicioSeccion() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      // Iniciar sesión con el correo electrónico y la contraseña proporcionados.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);

      // Cerrar el círculo de carga y regresar a la página anterior.
    } on FirebaseAuthException catch (e) {
      // Capturar errores de Firebase Authentication y mostrar mensajes de error.
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  //metidi para mensajes de error
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                //mensaje te emos extrañado
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Te Hemos Extrañado",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 50),
                //text fiel
                MyTextField(
                  textEdit: emailController,
                  hintText: "Correo Electronico",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                    textEdit: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true),
                const SizedBox(height: 10),
                MyButton(onTap: inicioSeccion, text: 'Ingresar'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No eres Mienbro',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Registrate Ahora',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
