
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../const.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: (){
              Constants.logout(context);
            },
            icon: const Tooltip(
              message: 'Cerrar sesión',
              child: Icon(Icons.logout_outlined),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inventories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> inventorySnapshot) {
          if (inventorySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (inventorySnapshot.hasError) {
            return Text('Error: ${inventorySnapshot.error}');
          }
    
          final inventoryProducts = inventorySnapshot.data?.docs ?? [];

           if (inventoryProducts.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }
    
          return ListView.builder(
            itemCount: inventoryProducts.length,
            itemBuilder: (context, index) {
              final productData = inventoryProducts[index].data() as Map<String, dynamic>;
              final productUid = productData['productUid']; // Asegúrate de que el campo sea el UID del producto
    
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('products').doc(productUid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (productSnapshot.hasError) {
                    return Text('Error: ${productSnapshot.error}');
                  }
    
                  final product = productSnapshot.data?.data() as Map<String, dynamic>;
    
                  
                  return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: product['image'] == ''
                              // ignore: sized_box_for_whitespace
                              ? Container(width: 60, height: 60, child: const Icon(Icons.image)) // Show an icon if no image URL is found
                              : Image.network(
                                  product['image'], // Use the image URL from the data
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ) 
                        ),
                        title: Text(product['name']),
                        subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cantidad: ${productData['cantidad']}'),
                          Text('Precio: ${product['price']}'),
                          Text('Presentación: ${product['presentation']}'),
                        ],
                      ),
                      ),
                    );
                },
              );
            },
          );
        },
      ),
    );
  }
}