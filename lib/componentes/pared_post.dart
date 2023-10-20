import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elmuro/componentes/comentario_boton.dart';
import 'package:elmuro/componentes/comentarios.dart';
import 'package:elmuro/componentes/megusta_botton.dart';
import 'package:elmuro/helper/helper_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> Likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.Likes,
  });
  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLike = false;
  final _commentTextController = TextEditingController();
  @override
  void iniState() {
    super.initState();
    isLike = widget.Likes.contains(currentUser.email);
  }

  //toggle Like
  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Usuarios Post')
        .doc(widget.postId);

    if (isLike) {
      // Si le gustó la publicación, agregue el correo electrónico del usuario al campo Me gusta.
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //Si la publicación ahora es diferente, elimine el correo electrónico del usuario de Me gusta.
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

// agregar comentarios
  void addComment(String commentText) {
    // escribir comentarios al post del usuario en una coleection
    FirebaseFirestore.instance
        .collection("Usuarios Post")
        .doc(widget.postId)
        .collection("Comentarios")
        .add({
      "Comentario Text": commentText,
      "Comento": currentUser.email,
      "Hora Comentario": Timestamp.now(),
    });
  }

// mostrar Cuadro de dialogo para escribir comentario
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Comentario"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(
            hintText: "Ecriba Comentario",
          ),
        ),
        actions: [
          // guardar
          TextButton(
            onPressed: () => {
              addComment(_commentTextController.text),
              //cerar el cuadro de texto
              Navigator.pop(context),
              //limpiar el controlador
              _commentTextController.clear(),
            },
            child: const Text("Enviar"),
          ),
          //cancelar
          TextButton(
              onPressed: () => {
                    Navigator.pop(context),
                    _commentTextController.clear(),
                  },
              child: const Text("Cancelar")),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  //boton me gusta
                  LikeButton(isLike: isLike, onTap: toggleLike),
                  const SizedBox(
                    height: 5,
                  ),
                  //no me gusta
                  Text(
                    widget.Likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              //comentarios
              Column(
                children: [
                  //boton de comentarios
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
                  //no me gusta
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //comentario debajo de la publicacion
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Usuarios Post")
                  .doc(widget.postId)
                  .collection("Comentarios")
                  .orderBy("Hora Comentario", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                //mostrar circulo de carga por mientras que no hay datos
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true, //para lista anidada
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Coment(
                      text: commentData['Comentario Text'],
                      user: commentData['Comento'],
                      time: formatData(commentData['Hora Comentario']),
                    );
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}
