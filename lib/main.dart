import 'package:flutter/material.dart';

void main() {
  runApp(ReceitasApp());
}

class ReceitasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Receitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: LoginPage(),
    );
  }
}

// ---------------- LOGIN PAGE -----------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final List<Map<String, String>> _usuarios = [];

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final senha = _senhaController.text;

      final user = _usuarios.firstWhere(
              (u) => u['email'] == email && u['senha'] == senha,
          orElse: () => {});

      if (user.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(usuario: user['nome']!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário não encontrado ou senha incorreta')),
        );
      }
    }
  }

  void _irParaCadastro() async {
    final novoUsuario = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CadastroPage()),
    );

    if (novoUsuario != null) {
      setState(() {
        _usuarios.add(novoUsuario);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.contains('@')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'A senha deve ter no mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text('Entrar')),
              TextButton(
                onPressed: _irParaCadastro,
                child: Text('Cadastrar novo usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- CADASTRO PAGE -----------------
class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'nome': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                value!.isEmpty ? 'Informe seu nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (value) => !value!.contains('@')
                    ? 'Digite um e-mail válido'
                    : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'A senha deve ter no mínimo 6 caracteres'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _cadastrar, child: Text('Cadastrar')),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME PAGE -----------------
class HomePage extends StatefulWidget {
  final String usuario;

  HomePage({required this.usuario});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;
  List<Map<String, String>> receitas = [];

  void _novaReceita() async {
    final nova = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NovaReceitaPage()),
    );

    if (nova != null) {
      setState(() {
        receitas.add(nova);
      });
    }
  }

  void _editarReceita(int index, Map<String, String> receita) async {
    final editada = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NovaReceitaPage(receita: receita)),
    );

    if (editada != null) {
      setState(() {
        receitas[index] = editada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Doces', 'Salgadas', 'Bebidas'];

    final receitasPorCategoria = {
      'Doces': receitas.where((r) => r['categoria'] == 'Doces').toList(),
      'Salgadas': receitas.where((r) => r['categoria'] == 'Salgadas').toList(),
      'Bebidas': receitas.where((r) => r['categoria'] == 'Bebidas').toList(),
    };

    return Scaffold(
      appBar: AppBar(title: Text('Olá, ${widget.usuario}!')),
      body: ListView(
        children: receitasPorCategoria[categorias[_indiceAtual]]!
            .asMap()
            .entries
            .map((entry) {
          int index = entry.key;
          Map<String, String> receita = entry.value;

          return Dismissible(
            key: Key(receita['nome']! + index.toString()),
            background: Container(color: Colors.redAccent),
            onDismissed: (direction) {
              final removida = receita;
              setState(() {
                receitas.remove(receita);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${receita['nome']} removida'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      setState(() {
                        receitas.insert(index, removida);
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(receita['nome']!),
                subtitle: Text(
                    '${receita['descricao']} • ${receita['tempo']} min'),
                trailing: Icon(Icons.edit),
                onTap: () => _editarReceita(index, receita),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _novaReceita,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) => setState(() => _indiceAtual = index),
        items: categorias
            .map((c) => BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: c,
        ))
            .toList(),
      ),
    );
  }
}

// ---------------- NOVA / EDITAR RECEITA PAGE -----------------
class NovaReceitaPage extends StatefulWidget {
  final Map<String, String>? receita;

  NovaReceitaPage({this.receita});

  @override
  _NovaReceitaPageState createState() => _NovaReceitaPageState();
}

class _NovaReceitaPageState extends State<NovaReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tempoController = TextEditingController();
  String _categoria = 'Doces';

  @override
  void initState() {
    super.initState();
    if (widget.receita != null) {
      _nomeController.text = widget.receita!['nome']!;
      _descricaoController.text = widget.receita!['descricao']!;
      _tempoController.text = widget.receita!['tempo']!;
      _categoria = widget.receita!['categoria']!;
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'tempo': _tempoController.text,
        'categoria': _categoria,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditando = widget.receita != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditando ? 'Editar Receita' : 'Nova Receita')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Receita'),
                validator: (v) =>
                v!.isEmpty ? 'Informe o nome da receita' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição Curta'),
                validator: (v) =>
                v!.isEmpty ? 'Informe uma descrição' : null,
              ),
              TextFormField(
                controller: _tempoController,
                decoration:
                InputDecoration(labelText: 'Tempo de Preparo (minutos)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o tempo';
                  if (int.tryParse(v) == null || int.parse(v) <= 0) {
                    return 'Informe um número positivo';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _categoria,
                items: ['Doces', 'Salgadas', 'Bebidas']
                    .map((c) =>
                    DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => _categoria = value!),
                decoration: InputDecoration(labelText: 'Categoria'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _salvar,
                  child: Text(isEditando ? 'Salvar Alterações' : 'Salvar Receita')),
            ],
          ),
        ),
      ),
    );
  }
}