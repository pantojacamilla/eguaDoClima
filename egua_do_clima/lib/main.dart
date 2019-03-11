import 'package:flutter/material.dart';
import './ui/eguaDoClima.dart';

void main() {
  runApp(
      new MaterialApp(
        title: 'Égua do Clima',
        home: new EguaDoClima(),
        // Retira o banner de debug mode do canto superior direito da tela
        debugShowCheckedModeBanner: false,
      )
  );
}