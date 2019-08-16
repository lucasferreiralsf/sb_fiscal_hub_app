class Inventario {
  final int total;
  final List<dynamic> data;

  Inventario({this.total, this.data});

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(total: json['total'], data: json['data']);
  }
}
