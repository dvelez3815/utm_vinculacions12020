// Generated by https://quicktype.io

import 'dart:convert';

import 'package:utm_vinculacion/modules/global/helpers.dart';

class Comida {
  int id;
  String nombre;
  String preparacion;
  List<String> ingredientes;
  String urlImagen;

  Comida({
    this.nombre,
    this.preparacion,
    this.ingredientes,
    this.urlImagen,
  }){
    this.id = generateID(); // Esto es tremendamente necesario
  }

  Comida.fromJson(Map<String, dynamic> item){
    id = item['id'];
    nombre = item['nombre'];
    preparacion = item['preparacion'];
    ingredientes = List<String>.from(jsonDecode(item['ingredientes'] ?? "[]"));
    urlImagen = item['urlImagen'];
  }

  Map<String, dynamic> toJson() => {
    "nombre":nombre,
    "preparacion":preparacion,
    "ingredientes": jsonEncode(ingredientes ?? []),
    "urlImagen":urlImagen,
  };

  set agregarIngredientes(List<String> ingredientes) {
    this.ingredientes.addAll(ingredientes);
  }

  set agregarIngrediente(String ingrediente){
    this.ingredientes.add(ingrediente);
  }
}
