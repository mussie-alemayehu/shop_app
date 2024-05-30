import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/product.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit_products';

  const EditProductsScreen({super.key});

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isValid = false;
  var _isInit = true;
  var _isLoading = false;
  var _productId = '';
  var _newProduct = Product(
    creatorId: FirebaseAuth.instance.currentUser!.uid,
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final isNull = ModalRoute.of(context)!.settings.arguments == null;
      if (!isNull) {
        _productId = ModalRoute.of(context)?.settings.arguments as String;
        _newProduct = Provider.of<ProductsProvider>(context)
            .findById(_productId.toString());
        _imageUrlController.text = _newProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(BuildContext context) async {
    _isValid = _form.currentState!.validate();
    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (_newProduct.id != '') {
          _form.currentState!.save();
          await Provider.of<ProductsProvider>(context, listen: false)
              .editItem(_productId, _newProduct);
        } else {
          _form.currentState!.save();
          await Provider.of<ProductsProvider>(context, listen: false)
              .addItem(_newProduct);
        }
      } catch (error) {
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error ocurred.'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: const Color(0xFFF9F9F9),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveForm(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _newProduct.title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                            creatorId: _newProduct.creatorId,
                            id: _newProduct.id,
                            title: value!,
                            description: _newProduct.description,
                            price: _newProduct.price,
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _newProduct.price == 0
                            ? null
                            : _newProduct.price.toStringAsFixed(2),
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be greater than or equal to zero.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                            creatorId: _newProduct.creatorId,
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: _newProduct.description,
                            price: double.parse(value!),
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _newProduct.description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the description of the product.';
                          }
                          if (value.length < 10) {
                            return 'Description must be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                            creatorId: _newProduct.creatorId,
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: value!,
                            price: _newProduct.price,
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 90,
                            width: 120,
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Text(
                                    'Add your image URL',
                                    textAlign: TextAlign.center,
                                  )
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onChanged: (_) => setState(() {}),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter an image url.';
                                }
                                if ((!value.startsWith('http') &&
                                        !value.startsWith('https')) ||
                                    (!value.endsWith('jpg') &&
                                        !value.endsWith('jpeg') &&
                                        !value.endsWith('png'))) {
                                  return 'Not a valid Url.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForm(context);
                              },
                              onSaved: (value) {
                                _newProduct = Product(
                                  creatorId: _newProduct.creatorId,
                                  id: _newProduct.id,
                                  title: _newProduct.title,
                                  description: _newProduct.description,
                                  price: _newProduct.price,
                                  imageUrl: value!,
                                  isFavorite: _newProduct.isFavorite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
