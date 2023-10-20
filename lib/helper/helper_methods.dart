import 'package:cloud_firestore/cloud_firestore.dart';

String formatData(Timestamp timestamp){
  //objeto recuperado de firebase
  // se convierte en cadena
  DateTime dateTime = timestamp.toDate();

  // obtener año
  String year = dateTime.year.toString();
  // obtener mes
  String mes = dateTime.month.toString();
  // String dia

  String day =dateTime.day.toString();
  // obtener hora
 // String hour = dateTime.hour.toString();

  String formattedDate = '$day/$mes/$year';
  return formattedDate;
}