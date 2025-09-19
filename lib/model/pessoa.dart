class Pessoa {
  final int id;
  final String nome;
  final int idade;

  Pessoa({required this.id, required this.nome, required this.idade});

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(id: json['id'], nome: json['nome'], idade: json['idade']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'idade': idade};
  }
}
