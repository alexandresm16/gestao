class MetaModel {
  final int? id;
  final String mes;
  final int ano;
  final double valor;

  MetaModel(this.id, this.mes, this.ano, this.valor);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mes': mes,
      'ano': ano,
      'valor': valor,
    };
  }

  factory MetaModel.fromMap(Map<String, dynamic> map) {
    return MetaModel(
      map['id'],
      map['mes'],
      map['ano'],
      map['valor'],
    );
  }
}
