import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';


class Conexion {
  static Future<Database> openDB() async {
    Database database = await openDatabase(join(await getDatabasesPath(), 'ptoventa.db'),
    
    onCreate: (db, version){
      db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, nickname TEXT, password TEXT, role TEXT)'
      );
    }, 
    version: 4,
    );
    return database;
  } 

  static Future<void> admin() async {

    String nickname = 'admin';

    Database database = await Conexion.openDB();

      // Verifica si el usuario ya existe en la base de datos
    List<Map<String, dynamic>> existingUsers = await database.query(
      'users',
      where: 'nickname = ?',
      whereArgs: [nickname],
    );

    if (existingUsers.isNotEmpty) {
      print("El usuario ya existe.");
    } else {
      // Inserta los datos del usuario
      await database.insert('users', {'nickname': 'admin', 'password': '123', 'role':'Admin'});

      print("Admin registrado");

    }

  }

  static Future<List<Users>> users() async {
    Database database = await Conexion.openDB();
    List<Map<String, dynamic>> users = await database.query('users');

    return List.generate(
      users.length, 
      (i) => Users(
        id: users[i]['id'],
        name: users[i]['name'],
        password: users[i]['password'],
        role: users[i]['role'],      
      )
    );
  }

}