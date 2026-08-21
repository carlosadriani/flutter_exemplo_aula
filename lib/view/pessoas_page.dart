import 'package:aplicacao_aula/model/user.dart';
import 'package:aplicacao_aula/repository/pessoa_repository.dart';
import 'package:aplicacao_aula/view/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class PessoasPage extends StatefulWidget {
  const PessoasPage({super.key});

  @override
  State<PessoasPage> createState() => _PessoasPageState();
}

class _PessoasPageState extends State<PessoasPage> {
  final PessoaRepository _repository = PessoaRepository();
  late Future<List<UserModel>> _futurePessoas;

  @override
  void initState() {
    super.initState();
    _futurePessoas = _repository.getPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text("Lista de Usuários"),
        actions: const [LogoutButton()],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _futurePessoas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum usuário encontrado."));
          } else {
            final pessoas = snapshot.data!;
            return ListView.builder(
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final user = pessoas[index];
                return Card(
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image ?? ""),
                      child: user.image == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      "${user.firstName ?? ''}  ${user.lastName ?? ''}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("email: ${user.email}"),
                          Text("idade: ${user.age ?? ''} anos"),
                          Text(
                            "sexo: ${user.gender == 'male' ? 'Masculino' : 'Feminino'}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
