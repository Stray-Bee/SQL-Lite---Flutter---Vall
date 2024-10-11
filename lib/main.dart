import 'package:flutter/material.dart';
import 'package:sqlite/PessoaDAO.dart';
import 'package:sqlite/pessoa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SQLite CRUD",
      home: Pag1(),
    );
  }
}
class Pag1 extends StatefulWidget {
  const Pag1({super.key});

  @override
  State<Pag1> createState() => _Pag1State();
}

class _Pag1State extends State<Pag1> {

final Pessoadao _pessoaDAO = Pessoadao();

final TextEditingController _nomeController = TextEditingController();
final TextEditingController _cpfController = TextEditingController();
final TextEditingController _cartaoController = TextEditingController();


List<Pessoa> _listaPessoas = [];
Pessoa? _pessoaAtual;

void _salvarEditar() async{
  if (_pessoaAtual == null){
    //inserir novo

    await _pessoaDAO.insertPessoa(
      Pessoa(
        nome: _nomeController.text, 
        cpf: _cpfController.text, 
        creditCard: _cartaoController.text,
      ));
  }else{
    _pessoaAtual!.nome = _nomeController.text;
    _pessoaAtual!.cpf = _cpfController.text;
    _pessoaAtual!.creditCard = _cartaoController.text;
    await _pessoaDAO.updatePessoa(_pessoaAtual!);
  }
  _nomeController.clear();
  _cpfController.clear();
  _cartaoController.clear();
  
  setState(() {
    _pessoaAtual = null;
  });
  
}

@override
  void initState() {
    super.initState();
    _loadPessoas();
  }

void _editarPessoa(Pessoa pessoa){
  _pessoaAtual = pessoa;
  _nomeController.text = pessoa.nome;
  _cpfController.text = pessoa.cpf;
  _cartaoController.text = pessoa.creditCard;
}

void _deletePessoa(int index) async{
  await _pessoaDAO.DeletePessoa(Pessoa(
    id: index, 
    nome:'', 
    cpf: '', 
    creditCard: '',
    ));
    _loadPessoas();
}

void _loadPessoas() async{
  List<Pessoa> listaTemp = await _pessoaDAO.selectPessoas();
  setState(() {
    _listaPessoas = listaTemp;
  });
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite CRUD"),
        backgroundColor: const Color.fromARGB(255, 171, 144, 233),
      ),
      body: Column(
        children: [
          Padding(padding: 
          const EdgeInsets.all(10.0),
          child: TextField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome'
            ),
          ),
          ),
           Padding(padding: 
           const EdgeInsets.all(10.0),
          child: TextField(
            controller: _cpfController,
            decoration: const InputDecoration(
              labelText: 'CPF'
            ),
          ),
          ),
           Padding(padding: 
           const EdgeInsets.all(10.0),
          child: TextField(
            controller: _cartaoController,
            decoration: const InputDecoration(
              labelText: 'Credit Card'
            ),
          ),
          ),
          ElevatedButton(onPressed: null, child: Text(_pessoaAtual == null ? 'Salvar' : 'Atualizar'),
          ),
          Expanded(child: ListView.builder(
            itemCount: _listaPessoas.length,
            itemBuilder: (context, index) {
              final Pessoa pessoa = _listaPessoas[index];
              return ListTile(
                title: Text('Nome: ${pessoa.nome} - CPF: ${pessoa.cpf}'),
                trailing: IconButton(
                  onPressed: (){
                    _deletePessoa(pessoa.id!);
                  }, 
                  icon: Icon(Icons.delete),
                ),
                onTap: (){
                  _editarPessoa(pessoa);
              },
              );
            },
          ),
          )
        ],
      ),
    );
  }
}