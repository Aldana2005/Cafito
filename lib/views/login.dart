import 'package:flutter/material.dart';
import 'package:cafito/views/admin/products.dart';
import 'package:cafito/views/register.dart';
import 'package:cafito/views/users/products.dart';
import 'package:sqflite/sqflite.dart';


import '../bd/conexion.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController(); // Agregado
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String? userDeviceToken;

  @override
    void initState() {
      super.initState();
      Conexion.admin();
    }
   @override
  void dispose() {
      _usernameController.dispose(); // Agregado para liberar recursos
      _passwordController.dispose();
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Image.asset('./assets/images/logo.jpg', width: 200),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    hintText: 'Ingresar usuario',
                    suffixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Ingresar contraseña',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText; // Cambiamos el valor para alternar la visibilidad de la contraseña
                        });
                      },
                      child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    )
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () async {
                  String nickname = _usernameController.text;
                  String password = _passwordController.text;

                  // Abre la base de datos
                  Database database = await Conexion.openDB();

                  // Busca el usuario en la base de datos
                  List<Map<String, dynamic>> users = await database.query(
                    'users',
                    where: 'nickname = ? AND password = ?',
                    whereArgs: [nickname, password],
                  );
                  

                  if (users.isNotEmpty) {
                    String userRole = users[0]['role'];

                    if (userRole == 'Admin') {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Product()),
                      );
                    }else{
                      if(userRole == 'User'){
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Products()),
                        );
                      }
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nombre de usuario o contraseña incorrectos')),
                    );
                  }

                  // Cierra la base de datos
                  await database.close();
                }, 
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
                },
                child: const Text('No tienes una cuenta? ¡Registrate aquí!', style: TextStyle(color: Colors.blue)),
              )
            ],
          )
        ]
      ),
    );
  }
}

