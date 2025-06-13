class ModeloCarta {
  final int id;
  final String valor;
  bool estaVolteada;
  bool estaEmparejada;

  ModeloCarta({
    required this.id,
    required this.valor,
    this.estaVolteada = false,
    this.estaEmparejada = false,
  });
}