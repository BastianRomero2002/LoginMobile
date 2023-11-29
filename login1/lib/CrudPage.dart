import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({Key? key}) : super(key: key);

  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  late Database _database;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasePath = await getDatabasesPath();
    final dbPath = path.join(databasePath!, 'crud_database.db');

    _database = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, activo INTEGER)',
      );
    });
  }

  Future<void> _insertUser(String username, String password) async {
    await _database.insert(
      'usuarios',
      {'username': username, 'password': password, 'activo': 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      return await _database.rawQuery(
          'SELECT * FROM usuarios WHERE username LIKE ?', ['%$searchText%']);
    } else {
      return await _database.query('usuarios');
    }
  }

  Future<void> _deleteUser(int id) async {
    await _database.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _updateUser(int id, String username, String password) async {
    await _database.update(
      'usuarios',
      {'username': username, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                if (username.isNotEmpty && password.isNotEmpty) {
                  await _insertUser(username, password);
                  _usernameController.clear();
                  _passwordController.clear();
                  _searchController.clear();
                  setState(() {});
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Usuario y Contraseña no pueden estar vacíos'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Alta'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(labelText: 'Buscar Usuario'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final users = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isActive = user['activo'] == 1;
                      return ListTile(
                        title: Text('Usuario: ${user['username']}'),
                        subtitle: Text('Contraseña: ${user['password']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(user);
                              },
                            ),
                            IconButton(
                              icon: isActive
                                  ? const Icon(Icons.radio_button_checked, color: Colors.green)
                                  : const Icon(Icons.radio_button_unchecked, color: Colors.red),
                              onPressed: () {
                                _toggleUserStatus(user);
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(user['id']);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(Map<String, dynamic> user) async {
    final TextEditingController _editUsernameController =
        TextEditingController(text: user['username']);
    final TextEditingController _editPasswordController =
        TextEditingController(text: user['password']);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: Column(
            children: [
              TextField(
                controller: _editUsernameController,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _editPasswordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final editedUsername = _editUsernameController.text.trim();
                final editedPassword = _editPasswordController.text.trim();
                await _updateUser(user['id'], editedUsername, editedPassword);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleUserStatus(Map<String, dynamic> user) async {
    final newStatus = user['activo'] == 1 ? 0 : 1;
    await _database.update('usuarios', {'activo': newStatus}, where: 'id = ?', whereArgs: [user['id']]);
  }
}
