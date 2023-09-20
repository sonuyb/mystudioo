import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'RespMain.dart';

class ProductProvider with ChangeNotifier {
  List<Products> _products = [];
  Products? _selectedProduct;
  List<Products> filteredProducts = [];
  List<Products> get products => _products;
  Products? get selectedProduct => _selectedProduct;

  // Fetch products from JSON or database and populate _products list

  void selectProduct(Products product) {
    _selectedProduct = product;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    var response=await http.get(Uri.parse("https://dummyjson.com/products"));
    var jsondata=jsonDecode(response.body.toString());
    var data=RespMain.fromJson(jsondata);
    var list= data.products;
    _products=list!;
    filteredProducts=_products;
    notifyListeners();
  }
  void filterProducts(String query) {

      filteredProducts = products.where((product) {
        return product.title!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      notifyListeners();

  }
  // Add a method to search for products by title or brand


}

