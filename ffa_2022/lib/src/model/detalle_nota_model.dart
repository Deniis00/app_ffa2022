class ListarDetalleNotas {
  List<DetalleNotaModel> items = new List();

  ListarDetalleNotas();

  ListarDetalleNotas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final estado = DetalleNotaModel.fromJson(item);
      items.add(estado);
    });
  }
}

class DetalleNotaModel {
  DetalleNotaModel(
      {this.codigo,
      this.descripcion_producto,
      this.estante,
      this.cantidad,
      this.cod_deposito,
      this.indica_cantidad,
      this.indica_varios_item,
      this.cantidad_item,
      this.separado,
      this.cant_separada});

  String codigo;
  String descripcion_producto;
  String estante;
  String cantidad;
  String cod_deposito;
  bool indica_cantidad;
  bool indica_varios_item;
  int cantidad_item;
  int separado;
  int cant_separada;

  factory DetalleNotaModel.fromJson(Map<String, dynamic> json) =>
      DetalleNotaModel(
        codigo: json["codigo"],
        descripcion_producto: json["descripcion_producto"],
        estante: json["estante"],
        cantidad: json["cantidad"],
        cod_deposito: json["cod_deposito"],
        indica_cantidad: json["indica_cantidad"],
        indica_varios_item: json["indica_varios_item"],
        cantidad_item: json["cantidad_item"],
        separado: json["separado"],
        cant_separada: json["cant_separada"]
      );
}
