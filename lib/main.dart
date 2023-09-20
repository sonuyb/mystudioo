

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystudioo/RespMain.dart';
import 'package:provider/provider.dart';

import 'datapro.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: MyApp()
      )

  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: ProductListScreen(),
    );
  }
}
// Product List Screen


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }
  @override
  Widget build(BuildContext context) {

    final productDataProvider = Provider.of<ProductProvider>(context, listen: false);
    final productsData = Provider.of<ProductProvider>(context).products;
    List<Products> filteredProducts = productsData
        .where((product) =>
    product.title!
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        product.brand!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Search by Title or Brand',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ProductDetailsScreen(selectedProduct: product,)),
                    );
                  },
                  title: Text("${product.title}"),
                  subtitle:  Text("${product.brand}"),
                  // Add more fields or widgets to display other product information
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// Product Details Screen
class ProductDetailsScreen extends StatelessWidget {
  late Products selectedProduct;

  ProductDetailsScreen({required this.selectedProduct});

  @override
  Widget build(BuildContext context) {


    if (selectedProduct == null) {
      return Center(child: Text('No product selected.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          Image.network('${selectedProduct.thumbnail}'),
          Text('${selectedProduct.title}'),
          Text('${selectedProduct.description}'),
          Text('Price: \$${selectedProduct.price?.toStringAsFixed(2)}'),
          Text('Discount: ${selectedProduct.discountPercentage}%'),
          Text('Rating: ${selectedProduct.rating}'),
          Text('Stock: ${selectedProduct.stock}'),
          Text('Brand: ${selectedProduct.brand}'),
        ],
      ),
    );
  }
}
