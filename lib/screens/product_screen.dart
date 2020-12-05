import 'package:FirestoreCRUDApp/models/product.dart';
import 'package:FirestoreCRUDApp/screens/add_edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<Product>>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('รายการสินค้า'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 30.0,), 
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEditProduct()));
            }
          )
        ],
      ),
      body: (products != null)
            ? ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(products[index].name),
                    trailing: Text(products[index].price.toString()),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditProduct(products[index])));
                    },
                  );
                })
            : Center(child: CircularProgressIndicator()));
  }
}