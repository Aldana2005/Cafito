import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../bd/conexion.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscureText = true; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrarme')),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10.0,),
                Padding(padding: const EdgeInsets.only(top: 10, bottom: 10), 
                child: Image.asset('./assets/images/logo.jpg', width: 200,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                        return null;
                      },
                    decoration: const InputDecoration(       
                      labelText: 'Usuario',
                      hintText: 'Ingrese nombre usuario',
                      suffixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Padding(padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                        return null;
                    },
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    decoration:  InputDecoration(       
                      labelText: 'Contraseña',
                      hintText: 'Ingrese contraseña',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText; // Cambiamos el valor para alternar la visibilidad de la contraseña
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), // Cambiamos el icono según la visibilidad
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                TextButton(onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    String nickname = _usernameController.text;
                    String password = _passwordController.text;
            
                    // Abre la base de datos
                    Database database = await Conexion.openDB();
            
                    // Verifica si el usuario ya existe en la base de datos
                    List<Map<String, dynamic>> existingUsers = await database.query(
                      'users',
                      where: 'nickname = ?',
                      whereArgs: [nickname],
                    );
            
                    if (existingUsers.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El usuario ya existe, intente registrando otro')),
                      );
                    } else {
                      // Inserta los datos del usuario
                      await database.insert('users', {'nickname': nickname, 'password': password, 'role':'User'});
            
                      // Muestra un mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario registrado con éxito')),
                      );
            
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                    }
            
                    // Cierra la base de datos
                    await database.close();
                  }
                }, 
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)), 
                child: const Text('Registrarme', style: TextStyle(color: Colors.white),),)
              ],
            ),
          )
        ]
      )
    );
  }
}