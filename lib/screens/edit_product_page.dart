// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  var _titleController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _imageController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageController.dispose();
  }

  void _saveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      var imageUrl =
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg';
      var editedProduct = Product(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descController.text,
        price: double.parse(_priceController.text),
        imageUrl: imageUrl,
      );

      Provider.of<Products>(context, listen: false).addProduct(editedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (_titleController.text.isEmpty) {
                      return 'Please enter product title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    //label: Text('Product Title'),
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (_priceController.text.isEmpty) {
                      return 'Please Enter price';
                    }
                    if (double.tryParse(_priceController.text)! < 0) {
                      return 'Please enter price greater than 0';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    //label: Text('Product Title'),
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  validator: (value) {
                    if (_descController.text.isEmpty) {
                      return 'Please enter description';
                    }
                    if (_descController.text.length < 10) {
                      return 'Please enter atleast 10 chars';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(border: Border.all()),
                      child: _imageController.text.isEmpty
                          ? Center(child: Text('Enter URL'))
                          : Image.network(
                              'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg'), //Image.network(_imageController.text),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: _imageController,
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (_imageController.text.isEmpty) {
                              return 'Please enter image Url';
                            }
                            return null;
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
