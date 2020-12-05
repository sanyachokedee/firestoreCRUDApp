import 'package:FirestoreCRUDApp/models/product.dart';
import 'package:FirestoreCRUDApp/providers/product_provider.dart';
import 'package:FirestoreCRUDApp/screens/product_screen.dart';
import 'package:FirestoreCRUDApp/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditProduct extends StatefulWidget {

  // Load Model มาสร้างเป็น Object
  final Product product;
  
  AddEditProduct([this.product]);

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {

  // TextField
  // TextFormField

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() { 
    if(widget.product == null){
      // เพิ่มรายการสินค้าใหม่
      nameController.text = "";
      priceController.text = "";
      new Future.delayed(Duration.zero, () {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        productProvider.loadValues(Product());
      });
    }else{
      // อัพเดทรายการสินค้า
      nameController.text = widget.product.name;
      priceController.text = widget.product.price.toString();
      new Future.delayed(Duration.zero, () {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        productProvider.loadValues(widget.product);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: (widget.product != null) ? Text('แก้ไขข้อมูลสินค้า') : Text('เพิ่มสินค้าใหม่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'ชื่อสินค้า'),
              onChanged: (value) {
                productProvider.changeName(value);
              },
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(hintText: 'ราคา'),
              onChanged: (value) => productProvider.changePrice(value),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              child: Text('บันทึกรายการ'),
              onPressed: () {
                if (nameController.text != "" && priceController.text != "") {
                  productProvider.saveProduct();
                  // ส่งกลับไปหน้า product
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductScreen()));
                } else {
                  BottomSheetWidget().bottomSheet(context, "มีข้อผิดพลาด", "ป้อนข้อมูลให้ครบก่อน");
                }
              },
            ),
            (widget.product != null) ?
            RaisedButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('ลบข้อมูลสินค้านี้'),
              onPressed: () {
                // set up the buttons
                Widget remindButton = FlatButton(
                  child: Text("ยืนยันลบข้อมูล"),
                  onPressed: () {
                    productProvider.removeProduct(widget.product.productId);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProductScreen()));
                  },
                );
                Widget cancelButton = FlatButton(
                  child: Text("ปิดหน้าต่าง"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("ยืนยันการลบข้อมูล"),
                  content: Text(
                      "หากต้องการลบข้อมูลนี้ กรุณาคลิ๊กยืนยันการลบข้อมูล"),
                  actions: [
                    remindButton,
                    cancelButton,
                  ],
                );
                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
            ) : Container(),
          ],
        ),
      )
    );


  }
}