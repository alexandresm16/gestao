class LimiteModel {
  int? id;
  String tipo;
  double valor;

  LimiteModel(this.id, this.tipo, this.valor);

  Map<String, dynamic> toMap() {
    return {'id': id, 'tipo': tipo, 'valor': valor};
  }

  factory LimiteModel.fromMap(Map<String, dynamic> map) {
    return LimiteModel(map['id'], map['tipo'], map['valor']);
  }
}
