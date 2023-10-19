import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmuro/componentes/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //usuario
  final currentUser = FirebaseAuth.instance.currentUser!;
  //todos los usuarios
  final usersCollection = FirebaseFirestore.instance.collection('Usuarios');
  //edit text
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Editar ' + field,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Entre Nuevo $field",
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //boton cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          //boton salvar
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
    //actualizar en firestore
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Pagina De Perfil'),
          backgroundColor: Colors.grey[900],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Usuarios')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            //obtener datos de usuarios
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  //foto de perfil
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Mail
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  //detalles de usuario
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Mis Detalles",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  //user Name
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'Nombre de Usuario',
                    onPressed: () => editField('username'),
                  ),
                  //biografia
                  MyTextBox(
                    text: userData['Biografia'],
                    sectionName: 'Biografia',
                    onPressed: () => editField('Biografia'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  //post de usuario
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Mis Posteos",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('ERROR${snapshot.hasError}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
