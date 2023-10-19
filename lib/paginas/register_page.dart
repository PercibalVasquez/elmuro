import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmuro/componentes/button.dart';
import 'package:elmuro/componentes/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirpasswordController = TextEditingController();

  void Register() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (passwordController.text != confirpasswordController.text) {
      Navigator.pop(context);
      //mostrat error a usuario
      displayMessage('Contraseñas Incorrectas');
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (context.mounted) Navigator.pop(context);

//después de crear el usuario, crea un nuevo documento en Firestore llamado Users
      FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(userCredential.user!.email).set({
            'username' : emailController.text.split('@')[0],//nombre de usuario antes del @
            'Biografia' : 'Biografia Vacia....', // inicial Biografia vacia
            //puedes adicionar mas campos si se necesita
          });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //mensage de error al crear usuario
      displayMessage(e.code);
    }
  }

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
                  "Creemos una Cuenta",
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
                const SizedBox(height: 10),
                MyTextField(
                    textEdit: confirpasswordController,
                    hintText: 'confirmar Contraseña',
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyButton(onTap: Register, text: 'Registrarse'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'eres Mienbro',
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
                        'ya tienes tu cuenta',
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
