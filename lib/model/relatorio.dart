class Relatorio {
  final int id;
  final String titulo;
  final String descricao;

  Relatorio({required this.id, required this.titulo, required this.descricao});

  factory Relatorio.fromJson(Map<String, dynamic> json) {
    return Relatorio(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'titulo': titulo, 'descricao': descricao};
  }
}
