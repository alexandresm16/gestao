class DespesaModel {
  int? _id;
  String _titulo;
  double _valor;
  String _categoria;
  DateTime _data;

  DespesaModel(
      this._id,
      this._titulo,
      this._valor,
      this._categoria,
      this._data,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'titulo': _titulo,
      'valor': _valor,
      'categoria': _categoria,
      'data': _data.millisecondsSinceEpoch, // <-- aqui a correção!
    };

    if (_id != null) {
      map['id'] = _id;
    }

    return map;
  }

  // Getters
  DateTime get data => _data;
  String get categoria => _categoria;
  double get valor => _valor;
  String get titulo => _titulo;
  int? get id => _id;
}
