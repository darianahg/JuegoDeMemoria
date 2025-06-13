import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../UX/styles.dart';

class WidgetCarta extends StatelessWidget {
  final ModeloCarta carta;
  final VoidCallback alPresionar;
  
  WidgetCarta({
    required this.carta,
    required this.alPresionar,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alPresionar,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: carta.estaEmparejada 
              ? EstilosApp.colorExito
              : carta.estaVolteada 
                  ? EstilosApp.colorCartaVolteada
                  : EstilosApp.colorCartaOculta,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: EstilosApp.colorBorde, width: 2),
        ),
        child: Center(
          child: Text(
            carta.estaVolteada || carta.estaEmparejada ? carta.valor : "?",
            style: EstilosApp.textoCartaGrande,
          ),
        ),
      ),
    );
  }
}