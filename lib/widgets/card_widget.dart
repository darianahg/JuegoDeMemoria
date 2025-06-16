import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../UX/styles.dart';

class WidgetCarta extends StatelessWidget {
  final ModeloCarta carta;
  final VoidCallback alPresionar;

  const WidgetCarta({
    super.key,
    required this.carta,
    required this.alPresionar,
  });
  @override
  Widget build(BuildContext context) {
    bool estaEsperando = carta.estaVolteada && !carta.estaEmparejada;

    return GestureDetector(
      onTap: alPresionar,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: carta.estaEmparejada
              ? EstilosApp.colorExito
              : carta.estaVolteada
                  ? (estaEsperando
                      ? EstilosApp.colorCartaVolteada.withOpacity(0.8)
                      : EstilosApp.colorCartaVolteada)
                  : EstilosApp.colorCartaOculta,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: estaEsperando ? Colors.orange : EstilosApp.colorBorde,
              width: estaEsperando ? 3 : 2),
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
