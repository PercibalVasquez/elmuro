
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmuro/componentes/MyCajon.dart';
import 'package:elmuro/componentes/pared_post.dart';
import 'package:elmuro/componentes/text_field.dart';
import 'package:elmuro/paginas/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final currentUser = FirebaseAuth.instance.currentUser!;
final textController = TextEditingController();

class _HomePageState extends State<HomePage> {
  void singOut() {
    FirebaseAuth.instance.signOut();
  }

  void postear() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("Usuarios Post").add({
        'UsuarioEmail': currentUser.email,
        'Mensaje': textController.text,
        'Hora': Timestamp.now(),
        'Likes': [],
      });
    }
    //limpar el texto despues de enviar el post
    setState(() {
      textController.clear();
    });
  }
  // navegar a pagina de perfil
  void gotoProfilePage(){
    //pop menu caja
    Navigator.pop(context);
    // viajar a pagina de perfil
     Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('La Pared'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap:  gotoProfilePage,
        onSignout: singOut,
      ),
      body: Center(
        child: Column(
          children: [
            //pared
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Usuarios Post")
                    .orderBy("Hora", descending: false)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, Index) {
                        final post = snapshots.data!.docs[Index];
                        return WallPost(
                          message: post['Mensaje'],
                          user: post['UsuarioEmail'],
                          postId: post.id,
                          Likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshots.hasError) {
                    return Center(
                      child: Text('Error' + snapshots.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            //para que postee
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                      child: MyTextField(
                          textEdit: textController,
                          hintText: 'Escribiendo en la Pared',
                          obscureText: false)),
                  IconButton(
                      onPressed: postear, icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),
            //mensaje
            Text(
              'Inicio Seccion: ' + currentUser.email!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
